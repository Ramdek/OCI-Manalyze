# This file is part of the global_install.sh script.
# It should not be executed alone.

MALWARE_BIN="/build/malware/pe_example"
YARA_FILE="/usr/local/share/manalyze/yara_rules/clamav.yara"

_find_rule_name_with_line() {

	local rule_line="${1}"

	head -n "${rule_line}" "${YARA_FILE}" | \
		tail -n 20 | \
		grep '^rule' | \
		tail -n 1
}

seek_malformatted_yara_rules() {

	printf "%s\n" "Seeking malformatted yara rules..."

	manalyze -p clamav "${MALWARE_BIN}" 2>&1 | \
		grep 'Error: \[Yara compiler\]' | \
		grep -Eo '\([0-9]*\)' | \
		tr -d '()' | \
		while read -r line; do
			local rule=""
			rule="$( _find_rule_name_with_line "${line}" )"

			printf "rule on line %s is '%s'\n" "${line}" "${rule}"
		done
}
