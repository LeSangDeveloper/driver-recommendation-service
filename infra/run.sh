#!bin/bash

service=$1
cmd=$2

AIRFLOW="airflow"
REDIS="redis"
KAFKA="kafka"
MLFLOW="mlflow"

get_docker_compose_file() {
    service=$1
    docker_compose_file="$service/docker-compose.yml"
    echo "$docker_compose_file"
}

up() {
    service=$1
    shift
    docker_compose_file=$(get_docker_compose_file $service)

    docker-compose -f "$docker_compose_file" up -d "$@"
}

up_airflow() {
    env_file="$AIRFLOW/.env"
    if [[ ! -f "$env_file" ]]; then
        echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" > "$env_file"
    fi
    up "$AIRFLOW" "$@"
}

up_redis() {
    up "$REDIS" "$@"
}

up_kafka() {
    up "$KAFKA" "$@"
}

up_mlflow() {
    up "$MLFLOW" "$@"
}

up_all() {
    up_airflow "$@"
    up_redis "$@"
    up_mlflow "$@"
    up_kafka "$@"
}

if [[ -z "$cmd" ]]; then
    echo "Missing command"
    exit 1
fi

if [[ -z "$service" ]]; then
    echo "Missing service"
    exit 1
fi

shift 2

case $cmd in
up)
    case $service in
        all)
            up_all "$@"
            ;;
        "$AIRFLOW")
            up_airflow "$@"
            ;;
        "$REDIS")
            up_redis "$@"
            ;;
        "$MLFLOW")
            up_mlflow "$@"
            ;;
        "$KAFKA")
            up_kafka "$@"
            ;;
    esac
    ;;
*)
    echo "Unknown command"
    exit 1
esac