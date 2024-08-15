IMAGE_NAME="driver-recommendation/model_serving:0.0"

build_image:
	docker build --tag ${IMAGE_NAME} -f ./deployment/Dockerfile .

run_container_test:
	docker run -d --network mlflow_default --name online_serving --restart on-failure -v /home/sang/Projects/driver-recommendation-service/model_serving/artifacts:/model_serving/artifacts -p 8172:8172 -t ${IMAGE_NAME} /bin/bash scripts/bentoml_helper.sh serve --port=8172 