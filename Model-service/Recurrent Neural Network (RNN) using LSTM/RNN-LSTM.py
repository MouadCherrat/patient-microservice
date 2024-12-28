import numpy as np
import pandas as pd
import tensorflow as tf
from tensorflow.keras.models import Sequential, load_model
from tensorflow.keras.layers import LSTM, Dense
from tensorflow.keras.callbacks import TensorBoard
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
import joblib
import datetime
import os

# Load the CSV dataset and preprocess data
def load_and_preprocess_data(csv_path, time_steps=10):
    data = pd.read_csv(csv_path)
    label_encoder = LabelEncoder()
    data['Label'] = label_encoder.fit_transform(data['Label'])
    # Process data into sequences
    sequences = []
    labels = []
    grouped = data.groupby('SequenceID')  # Group by SequenceID
    for _, group in grouped:
        for i in range(len(group) - time_steps + 1):
            sequence = group.iloc[i:i+time_steps][['Sensor_X', 'Sensor_Y', 'Sensor_Z']].values
            label = group.iloc[i+time_steps-1]['Label']
            sequences.append(sequence)
            labels.append(label)
    
    return np.array(sequences), np.array(labels), label_encoder

# Load the data
csv_path = 'C:/Users/DELL/Desktop/behavior_data.csv'
X, y, label_encoder = load_and_preprocess_data(csv_path, time_steps=10)

# Split into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# for TensorBoard logs
log_dir = "logs/fit/" + datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
os.makedirs(log_dir, exist_ok=True)

# TensorBoard callback
tensorboard_callback = TensorBoard(log_dir=log_dir, histogram_freq=1)

# Build the LSTM model
model = Sequential([
    LSTM(64, input_shape=(10, 3)),          # LSTM with 64 units
    Dense(32, activation='relu'),           # Dense layer with 32 neurons
    Dense(len(label_encoder.classes_), activation='softmax')
])

# Compile the model
model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])

model.fit(
    X_train, y_train,
    epochs=10,
    batch_size=16,
    validation_split=0.2,
    callbacks=[tensorboard_callback]
)

# Evaluate the model
loss, accuracy = model.evaluate(X_test, y_test)
print(f"Test Loss: {loss}, Test Accuracy: {accuracy}")

# Save the model and label encoder
model.save('behavior_detection_model.h5')
joblib.dump(label_encoder, 'label_encoder.pkl')

# Load model and label encoder for prediction
model = load_model('behavior_detection_model.h5')
label_encoder = joblib.load('label_encoder.pkl')

# Function to generate random sensor data and make predictions
def test_random_sequence(time_steps=10, sensor_count=3):
    random_sequence = np.random.normal(loc=0.0, scale=1.0, size=(1, time_steps, sensor_count))    
    predictions = model.predict(random_sequence)
    predicted_class = np.argmax(predictions)
    # Decode the predicted class to the behavior label
    predicted_label = label_encoder.inverse_transform([predicted_class])[0]
    
    # Output the result
    print(f"Random sensor sequence: {random_sequence}")
    print(f"Predicted behavior class: {predicted_label}")

# Test with random data
test_random_sequence()

# tensorboard --logdir=logs/fit