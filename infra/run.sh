#!bin/bash

service=$1
cmd=$2

AIRFLOW="airflow"
REDIS="redis"
KAFKA="kafka"
MLFLOW="mlflow"
RESTART_SLEEP_SEC=2

usage() {
    echo "run.sh <service> <command> [options]"
    echo "Available services:"
    echo "  all                 all services"
    echo "  $AIRFLOW            airflow service"
    echo "  $REDIS              redis service"
    echo "  $KAFKA              kafka service"
    echo "  $MLFLOW             mlflow service"
    echo "Availables commands:"
    echo "  up                  deploy services"
    echo "  down                stop and remove containers, networks"
    echo "  restart             down then up"
}

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

down() {
    service=$1
    echo "$service"
    shift
    docker_compose_file=$(get_docker_compose_file $service)

    docker-compose -f "$docker_compose_file" down "$@"
}

down_kafka() {
    down "$KAFKA" "$@"
}

down_airflow() {
    down "$AIRFLOW" "$@"
}

down_mlflow() {
    down "$MLFLOW" "$@"
}

down_redis() {
    down "$REDIS" "$@"
}

down_all() {
    echo "all"
    down_airflow "$@"
    down_kafka "$@"
    down_redis "$@"
    down_mlflow "$@"
}

if [[ -z "$cmd" ]]; then
    echo "Missing command"
    usage
    exit 1
fi

if [[ -z "$service" ]]; then
    echo "Missing service"
    usage
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
        *)
            echo "Unknwown service"
            usage
            ;;
    esac
    ;;
down)
    case $service in
        all)
            down_all "$@"
            ;;
        "$AIRFLOW")
            down_airflow "$@"
            ;;
        "$KAFKA")
            down_kafka "$@"
            ;;
        "$REDIS")
            down_redis "$@"
            ;;
        "$MLFLOW")
            down_mlflow "$@"
            ;;
        *)
            echo "Unknown service"
            usage
            ;;
    esac
    ;;
restart)
    case $service in
        all)
            down_all "$@"
            sleep $RESTART_SLEEP_SEC
            up_all "$@"
            ;;
        "$AIRFLOW")
            down_airflow "$@"
            sleep $RESTART_SLEEP_SEC
            up_airflow
            ;;
        "$KAFKA")
            down_kafka "$@"
            sleep $RESTART_SLEEP_SEC
            up_kafka
            ;;
        "$REDIS")
            down_redis "$@"
            sleep $RESTART_SLEEP_SEC
            up_redis
            ;;
        "$MLFLOW")
            down_mlflow "$@"
            sleep $RESTART_SLEEP_SEC
            up_mlflow
            ;;
        *)
            echo "Unknown service"
            usage
            ;;
*)
    echo "Unknown command"
    usage
    exit 1
esac
