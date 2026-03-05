# This file is part of the global_install.sh script.
# It should not be executed alone.

MALWARE_BIN="/build/malware/pe_example"
MALFORMATTED_YARA_RULES="/build/malformatted_rules"
YARA_FILE="/usr/local/share/manalyze/yara_rules/clamav.yara"

_remove_yara_rule() {

	local rule_name="${1}"

	sed -i "/${rule_name}/,/^}/d" "${YARA_FILE}"
}

_clear_bad_format_yara_rules() {

	printf "%s\n" "Cleaning malformatted yara rules"

	while read -r rule; do
		_remove_yara_rule "${rule}"
	done < "${MALFORMATTED_YARA_RULES}"
}

_init_yara_cache() {

	printf "%s\n" "Building application cache (blank run)"
	manalyze -p all "${MALWARE_BIN}" >/dev/null
}

manalyze_install() {

	printf "%s\n" "Installing manalyze"

	_clear_bad_format_yara_rules
	_init_yara_cache

	mv /usr/local/bin/manalyze /usr/local/bin/manalyze.bin
	cp /build/runtime/manalyze /usr/local/bin/manalyze
	cp /build/runtime/entrypoint /entrypoint
}
