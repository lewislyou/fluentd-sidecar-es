.PHONY:	build push

TAG = 1.2

build:
#	docker build -t registry.meizu.com/common/fluentd-sidecar-es:$(TAG) .
	docker build -t reg.local:5000/fluentd-sidecar-es:$(TAG) .

push:
	gcloud docker push registry.meizu.com/common/fluentd-sidecar-es:$(TAG)
