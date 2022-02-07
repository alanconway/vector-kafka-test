#!/bin/bash

case $1 in
    deploy)
	oc create ns kafka
	kubectl create -f 'https://strimzi.io/install/latest?namespace=kafka' -n kafka
	kubectl apply -f https://strimzi.io/examples/latest/kafka/kafka-persistent-single.yaml -n kafka
	kubectl wait kafka/my-cluster --for=condition=Ready --timeout=300s -n kafka
	;;

    undeploy)
	oc delete --ignore-not-found ns/kafka
	kubectl delete --ignore-not-found -f 'https://strimzi.io/install/latest?namespace=kafka' -n kafka
	;;

    producer)
	kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.27.1-kafka-3.0.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --broker-list my-cluster-kafka-bootstrap:9092 --topic my-topic
	;;

    consumer)
	kubectl delete -n kafka --ignore-not-found pod kafka-consumer
	kubectl run -n kafka kafka-consumer -ti --image=quay.io/strimzi/kafka:0.27.1-kafka-3.0.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic --from-beginning
	;;
    *)
	echo "bad command"; exit 1
	;;
esac

# Full hostname: my-cluster-kafka-bootstrap.kafka.svc.cluster.local:9092
