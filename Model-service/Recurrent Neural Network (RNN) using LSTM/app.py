from flask import Flask, request, jsonify
import numpy as np
from tensorflow.keras.models import load_model # type: ignore
import joblib
from flask_cors import CORS
import py_eureka_client.eureka_client as eureka_client


rest_port = 5000
eureka_client.init(eureka_server="http://localhost:8089/eureka",
                   app_name="model-service",
                   instance_port=rest_port)

model = load_model('behavior_detection_model.h5')
label_encoder = joblib.load('label_encoder.pkl')

app = Flask(__name__)
CORS(app)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Extract data from POST request
        data = request.get_json()
        sequence = np.array(data['sequence'])

        if sequence.shape != (1, 10, 3):
            return jsonify({'error': 'Invalid input shape, expected (1, 10, 3)'}), 400

        # Make predictions
        predictions = model.predict(sequence)
        predicted_class = np.argmax(predictions)
        predicted_label = label_encoder.inverse_transform([predicted_class])[0]

        # Return the predicted behavior and confidence
        return jsonify({'predicted_label': predicted_label, 'confidence': float(np.max(predictions))})
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port = rest_port)
