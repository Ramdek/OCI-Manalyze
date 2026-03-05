#!/usr/bin/env sh
#
# Author:   Jonathan <jonathan.sling@isen-ouest.yncrea.fr>
#
# Manalyze build script (alpine)

# Script settings
set -o errexit
set -o nounset
set -o pipefail

script_dir="$(dirname "${0}")"
readonly script_dir

source "${script_dir}/noshellkit/noshellkit.sh"

main() {

	local arg="${1:-}"

	if [[ "${arg}" == "distroless" ]]; then
		execute_install manalyze_distroless
		add_binaries_and_libs /bin/busybox
		add_default_alpine
	elif [[ "${arg}" == "seek_malformatted_yara_rules" ]]; then

		export KEEP_PYTHON=true

		execute_install manalyze_compile
		execute_install seek_malformatted_yara_rules
	else
		execute_install manalyze_compile
		execute_install manalyze_install
	fi
}

main "$@"
