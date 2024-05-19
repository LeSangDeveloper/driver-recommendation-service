build_image:
	docker build --tag test-image -f ./deployment/Dockerfile .

run_image:
	sudo docker run --network="host" -p 80:80 test-image -d