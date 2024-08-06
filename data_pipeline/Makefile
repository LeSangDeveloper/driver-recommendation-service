IMAGE_NAME="driver-recommendation/data_pipeline:0.0"

build_image:
	docker build --tag ${IMAGE_NAME} -f ./deployment/Dockerfile .

run_image:
	sudo docker run --network="host" -p 80:80 -t driver-recommendation/data_pipeline:0.0 -d