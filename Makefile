IMAGE_NAME = ramdek/manalyze

platforms = image.amd64 image.arm64

ifeq ($(shell command -v podman 2>/dev/null),)
	OCI_CMD = docker
else
	OCI_CMD = podman
endif

multiarch_rule = $(filter multiarch-image.%,$(MAKECMDGOALS))

ifneq ($(multiarch_rule),)
	override TAG = $(multiarch_rule:multiarch-image.%=%)
else
	TAG ?= dev
endif

.PHONY: all
all: image

.PHONY: clean
clean:
	rm -f manifest
	rm -f image.*
	rm -f multiarch-image.*
	$(OCI_CMD) manifest rm $(IMAGE_NAME):$(TAG)

image: submodules
	$(OCI_CMD) build -t $(IMAGE_NAME):$(TAG) .

multiarch-image.%: submodules manifest image.amd64 image.arm64
	@touch $@

manifest:
	@[ -n "$(TAG)" ] \
		|| ( echo "TAG variable must be set for this rule"; exit 1 )
	$(OCI_CMD) manifest create $(IMAGE_NAME):$(TAG)
	@touch $@

$(platforms): image.%:
	$(OCI_CMD) build --platform linux/$* -t $(IMAGE_NAME):$(TAG)-$* --manifest $(IMAGE_NAME):$(TAG) .
	@touch image.$*

submodules:
	git submodule init
	git submodule update
