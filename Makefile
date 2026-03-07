IMAGE_NAME = ramdek/manalyze
TARGET ?= final

platforms = image.amd64 image.arm64

ifeq ($(shell command -v podman 2>/dev/null),)
	OCI_CMD = docker
else
	OCI_CMD = podman
endif

OCI_OPT ?= --no-cache

multiarch_rule = $(filter multiarch-image.%,$(MAKECMDGOALS))
push_rule = $(filter push.%,$(MAKECMDGOALS))

ifneq ($(multiarch_rule),)
	override TAG = $(multiarch_rule:multiarch-image.%=%)
else ifneq ($(push_rule),)
	override TAG = $(push_rule:push.%=%)
else
	TAG ?= dev
endif

.PHONY: all
all: help

.PHONY: help
help:
	@echo -e "Available targets:\n\
	    clean                  remove existing manifest for IMAGE_NAME and TAG\n\
	    image                  build image for current platform\n\
	    image.(platform)       build image for given platform (amd64/arm64)\n\
	    multiarch-image.(tag)  build multi-architecture image for given tag\n\
	    push.(tag)             push multi-architecture image to github registry\n\
	    seek_bad_yara_rules    list malformatted yara rules\n\
	Available variables:\n\
	    IMAGE_NAME             image name (default: ramdek/manalyze)\n\
	    OCI_CMD                container command to use (podman/docker)\n\
	    OCI_OPT                container build option (default --no-cache)\n\
	    REGISTRY               container registry domain name to push to\n\
	    TAG                    image tag (default: dev)\n\
	    TARGET                 image build target (default: final)"

.PHONY: clean
clean:
	rm -f manifest
	rm -f image.*
	rm -f multiarch-image.*
	$(OCI_CMD) manifest rm $(IMAGE_NAME):$(TAG)

image: submodules
	$(OCI_CMD) build --target $(TARGET) -t $(IMAGE_NAME):$(TAG) $(OCI_OPT) .

multiarch-image.%: submodules manifest image.amd64 image.arm64
	@touch $@

manifest:
	@[ -n "$(TAG)" ] \
		|| ( echo "TAG variable must be set for this rule"; exit 1 )
	$(OCI_CMD) manifest create \
		--annotation="org.opencontainers.image.description=$$( \
				grep -o 'description=".*"' Dockerfile | sed -E 's/description=|"//g' \
			)" \
		--annotation="org.opencontainers.image.base.name=$(if $(filter $(TARGET),dev),alpine,scratch)" \
		--annotation="org.opencontainers.image.created=$$( date -u -Is | sed "s/+.*/Z/" )" \
		--annotation="org.opencontainers.image.revision=$$( git rev-parse HEAD )" \
		--annotation="org.opencontainers.image.source=https://github.com/Ramdek/OCI-Manalyze.git#$$( git rev-parse HEAD )" \
		--annotation="org.opencontainers.image.url=https://ghcr.io/ramdek/manalyze" \
		--annotation="org.opencontainers.image.version=$(TAG)"
		$(IMAGE_NAME):$(TAG)
	@touch $@

$(platforms): image.%:
	$(OCI_CMD) build --target $(TARGET) --platform linux/$* -t $(IMAGE_NAME):$(TAG)-$* --manifest $(IMAGE_NAME):$(TAG) $(OCI_OPT) .
	@touch image.$*

push.%: REGISTRY ?= ghcr.io
push.%:
	@[[ "$(TAG)" != dev ]] \
		|| ( echo "Won't push default image name !"; exit 1 )
	@echo "Pushing $(IMAGE_NAME):$(TAG) to $(REGISTRY)"
	@read -p "Enter username: " username; \
	read -sp "Enter token: " token; \
	echo ; \
	echo "$${token}" | $(OCI_CMD) login $(REGISTRY) -u $${username} --password-stdin

	$(OCI_CMD) manifest push --all $(IMAGE_NAME):$(TAG) \
	"docker://$(REGISTRY)/$(IMAGE_NAME):$(TAG)"

.PHONY: seek_bad_yara_rules
seek_bad_yara_rules:
	@$(OCI_CMD) run -it --rm -v ./Manalyze:/Manalyze -v ./build:/build alpine \
		sh -c "/build/global-install.sh seek_malformatted_yara_rules"
	@rm -r  Manalyze/bin/yara_rules/__pycache__/

submodules:
	git submodule init
	git submodule update
