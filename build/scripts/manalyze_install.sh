# This file is part of the global_install.sh script.
# It should not be executed alone.

MALWARE_BIN="/build/malware/pe_example"

_init_yara_cache() {

	printf "%s\n" "Building application cache (blank run)"
	manalyze -p all "${MALWARE_BIN}" >/dev/null
}

manalyze_install() {

	printf "%s\n" "Installing manalyze"

	_init_yara_cache

	mv /usr/local/bin/manalyze /usr/local/bin/manalyze.bin
	cp /build/runtime/manalyze /usr/local/bin/manalyze
	cp /build/runtime/entrypoint /entrypoint
}
