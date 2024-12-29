# Advanced Patient Monitoring System (Version 1.0.0)



The **Advanced Patient Monitoring System** is a cutting-edge platform that combines GPS tracking, deep learning, and real-time notifications to enhance patient safety. Built using Flutter, Spring Boot, and Angular, this modular solution ensures scalability, fault tolerance, and efficient monitoring of high-risk patients.

---

## **Table of Contents**
- [Software Architecture](#software-architecture)
- [Docker Image](#docker-image)
- [Frontend](#frontend)
- [Backend](#backend)
- [Getting Started](#getting-started)
- [Usage](#usage)
---

## **Software Architecture**

![architecture](https://github.com/user-attachments/assets/82548496-ee6d-473b-9655-72fe885bcdbf)


The architecture consists of:
- **Frontend:** Flutter mobile apps for patients and doctors, Angular admin panel for administrators.
- **Backend:** Microservices built with Spring Boot and Flask.
- **Communication:** RESTful APIs.
- **Monitoring Tools:** Grafana, Prometheus, and TensorBoard for system and model performance tracking.

---

## **Docker Image**

The application uses Docker Compose for containerized deployment:

```yaml
version: "3.8"

services:
  # MySQL Service
  mysql:
    image: mysql:latest
    container_name: mysql-patient
    volumes:
      - mysql_data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: secret
    ports:
      - "3307:3306"
    networks:
      - app-net

  # phpMyAdmin for Database Management
  phpmyadmin:
    image: phpmyadmin
    container_name: phpmyadmin-patient
    environment:
      PMA_HOST: mysql
      PMA_PORT: 3306
      MYSQL_ROOT_PASSWORD: secret
    ports:
      - "81:80"
    depends_on:
      - mysql
    networks:
      - app-net

  # Prometheus Service
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    networks:
      - monitoring
      - app-net

  # Grafana Service
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin  # Default Grafana password
    ports:
      - "3000:3000"  # Grafana on port 3000
    depends_on:
      - prometheus
    networks:
      - monitoring
    volumes:
      - grafana-data:/var/lib/grafana
  keycloak:
    image: quay.io/keycloak/keycloak:24.0.0
    container_name: Keycloak_patient
    ports:
      - "9000:8080"
    environment:
      KEYCLOAK_ADMIN: "admin"
      KEYCLOAK_ADMIN_PASSWORD: "admin"
    command:
      - "start-dev"
    volumes:
      - keycloak_data:/opt/keycloak/data
    networks:
      - app-net
networks:
  monitoring:
    driver: bridge
  app-net:
    driver: bridge

volumes:
  mysql_data:
  keycloak_data:
  grafana-data:

```

---

## **Frontend**

### Technologies Used:
- **Flutter** for mobile applications.
- **Angular** for the admin panel.
- **HTML, CSS, and TypeScript** for UI/UX.

### Flutter Features:
- Real-time GPS tracking for patients.
- Doctor dashboard with alert notifications.
- Patient interface for launching monitoring.

### Angular Features:
- Patient and doctor management.
- Real-time alert tracking.

---

## **Backend**

### Technologies Used:
- **Spring Boot:** Core microservices (Patient, Model, Alert, User).
- **Flask:** Hosts the RNN-LSTM model for event classification.
- **MySQL:** Database for storing GPS logs, alerts, and user data.

### Backend Structure:
1. **Controller Layer:** Handles API requests and responses.
2. **Service Layer:** Business logic for processing data.
3. **Repository Layer:** Database interaction via JPA.

---

## **Getting Started**

### Prerequisites:

1. **Git:** [Download and Install Git](https://git-scm.com/)  
   - Used for cloning the repository and version control.

2. **Docker:** [Download Docker](https://www.docker.com/products/docker-desktop)  
   - Required for containerizing and running the microservices.

3. **Flutter SDK (3.0+):** [Download Flutter](https://flutter.dev/)  
   - Used for the mobile application development (Patient and Doctor apps).

4. **Node.js (16.x or later):** [Download Node.js](https://nodejs.org/)  
   - Required for running the Angular-based admin panel.

5. **Java (17):** [Download Java](https://www.oracle.com/java/technologies/javase-jdk17-downloads.html)  
   - Necessary for running Spring Boot microservices.
  
6. **Python (3.10+):** [Download Python](https://www.python.org/downloads/)
   - Used for the Flask microservice hosting the deep learning model.



### Setup Instructions:

#### Backend:
1. Clone the repository:
   ```bash
   git clone (https://github.com/MouadCherrat/patient-microservice)
   cd patient-microservice
   ```
2. Install dependencies:
   ```bash
   mvn clean install
   ```
3. Start the backend:
   ```bash
   mvn spring-boot:run
   ```

#### Frontend:
1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the frontend:
   ```bash
   ng serve
   ```

#### Flutter:
1. Navigate to the Flutter directory:
   ```bash
   cd flutter-app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Start the app:
   ```bash
   flutter run
   ```

---

## **Video Demonstration**

[Watch the demonstration video](https://youtu.be/YourDemoVideoLink)

---

## **Usage**

### Authentication:
- **Admin Login:**
  - Email: `admin@gmail.com`
  - Password: `admin123`
- **Doctor Login:**
  - Email: `kahlil@gmail.com`
  - Password: `doctor123`
- **Patient Login:**
  - Email: `mouad@gmail.com`
  - Password: `patient123`

### Features:
- Monitor real-time GPS data.
- Classify patient events using RNN-LSTM.
- Send real-time alerts for critical events.

---

## **Contributors**

- Khalil Souidi ([(https://github.com/KhalilSouidi](https://github.com/khalil-souidi))
- Mouad Cherrat ([https://github.com/MouadCherrat](https://github.com/MouadCherrat))
- Zouhair Lafrougui ([https://github.com/ZouhairLafrougui](https://github.com/zouhair458))
- Imane EL Alji ([https://github.com/ImaneELAlji](https://github.com/imane225))
- Kenza Ouattassa ([(https://github.com/KenzaOuattassa](https://github.com/kenzaouattass))

---

