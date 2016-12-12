.PHONY:	build push

TAG = 1.2

build:
	docker build -t gcr.io/fluentd-sidecar-es:$(TAG) .

push:
	gcloud docker push gcr.io/fluentd-sidecar-es:$(TAG)
