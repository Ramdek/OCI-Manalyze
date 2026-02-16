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

	execute_install manalyze_install
	add_binaries_and_libs /bin/busybox
	add_default_alpine
}

main "$@"
