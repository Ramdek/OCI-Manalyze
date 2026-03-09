define HELP_TARGETS +=
\n    help                   show this help\n\
\0   submodules             init repository submodules\n\
\0   seek_bad_yara_rules    list malformatted yara rules
endef

.PHONY: all
all: help

.PHONY: help
help:
	@echo -e "Available targets:$(HELP_TARGETS)\n\
	Available variables:$(HELP_VARIABLES)"

.PHONY: submodules
submodules:
	git submodule init
	git submodule update

.PHONY: seek_bad_yara_rules
seek_bad_yara_rules:
	@$(OCI_CMD) run -it --rm -v ./Manalyze:/Manalyze -v ./build:/build alpine \
		sh -c "/build/global-install.sh seek_malformatted_yara_rules"
	@rm -r  Manalyze/bin/yara_rules/__pycache__/

IMAGE_NAME = ramdek/manalyze
# Static IMAGE_URL
IMAGE_URL=https://ghcr.io/$(IMAGE_NAME)
REGISTRY = ghcr.io
SOURCE_COMMIT_URL=https://github.com/Ramdek/OCI-Manalyze.git\#

-include makefiles/oci_image.mk
