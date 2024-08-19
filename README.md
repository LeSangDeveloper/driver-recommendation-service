# Driver Recommendation Service

## Overview

This project is a Driver Recommendation Service designed to recommend the driver with the highest probability of successfully completing a trip for a customer. The service leverages machine learning techniques and a robust infrastructure to provide reliable and efficient recommendations.

## Features

- **Data Pipeline & Model Training**: Built using Apache Airflow to manage the entire workflow from data ingestion to model training, deployment, and batch predictions.
- **Modeling**: Utilizes Elastic-Net from scikit-learn to build the predictive model.
- **Model Management**: MLflow is used for model registry, storing model metadata, and tracking training experiments.
- **Deployment**: The entire service is containerized using Docker, with Docker Swarm orchestrating the deployment. Additional deployment support is provided via custom Bash scripts and a Makefile.
- **CI/CD**: Jenkins is employed for continuous integration and continuous deployment, ensuring a smooth and automated development process.

## Infrastructure

- **Docker & Docker Swarm**: All components are containerized, allowing for easy deployment and scaling. Docker Swarm is used for managing the cluster of Docker containers.
- **Apache Airflow**: Orchestrates the data pipeline, model training, and batch prediction tasks, ensuring that each step is executed in the correct order and with the necessary dependencies.
- **MLflow**: Facilitates the management of the machine learning lifecycle, including experiment tracking, model versioning, and deployment.
- **Jenkins**: Handles CI/CD, automating the build, test, and deployment processes.

## How to Run

### Prerequisites

- Docker and Docker Swarm installed
- Apache Airflow setup
- MLflow installed and configured
- Jenkins for CI/CD

### Steps

1. Clone the repository:

   ```bash
   git clone https://github.com/LeSangDeveloper/driver-recommendation-service.git
   cd driver-recommendation-service

2. Run each service by `cd` to each folder
3. Setup DAGs in /infra/airflow/

### Scripts in each folder

- **Bash Scripts**:  A set of custom scripts to facilitate the deployment process. 
- **Make file**: A Makefile is provided to automate common tasks such as building and deploying containers.

### Model

- **Algoritms**: Elastic-Net from scikit-learn is used for training the model, providing a balance between L1 and L2 regularization.
