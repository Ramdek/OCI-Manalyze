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

_remove_yara_rule() {

	local rule_name="${1}"

	sed -i "/${rule_name}/,/^}/d" "${YARA_FILE}"
}

_clear_bad_format_yara_rules() {

	local rule_names_file="$( mktemp )"

	printf "%s\n" "Removing bad format yara rules"

	manalyze -p clamav "${MALWARE_BIN}" 2>&1 | \
		grep 'Error: \[Yara compiler\]' | \
		grep -Eo '\([0-9]*\)' | \
		tr -d '()' | \
		while read -r line; do
			local rule=""
			rule="$( _find_rule_name_with_line "${line}" )"

			printf "rule on line %s is '%s'\n" "${line}" "${rule}"
			echo "${rule}" >> "${rule_names_file}"
		done

	while read -r rule; do
		_remove_yara_rule "${rule}"
	done < "${rule_names_file}"
}

_manalyze_distroless() {

	cp_folder_to_distroless /usr/bin
	cp_folder_to_distroless /usr/local/bin/manalyze
	cp_folder_to_distroless /usr/local/share/manalyze
	cp_folder_to_distroless /usr/local/etc/manalyze
	cp_folder_to_distroless /root/.cache

	mv /usr/local/bin/manalyze /usr/local/bin/manalyze.bin
	add_binaries_and_libs \
		manalyze.bin

	cp /build/runtime/manalyze /usr/local/bin/manalyze
	cp_files_to_distroless "/usr/local/bin/manalyze"
}

_build_manalyze() {

	printf "%s\n" "Building Manalyze"

	(
		cd Manalyze
		cmake .
		make -j 5

		printf "%s\n" "Generating clamav signatures"
		/Manalyze/bin/yara_rules/update_clamav_signatures.py

		printf "%s\n" "Removing python files (cache & bin utils)"
		rm -rf /Manalyze/bin/yara_rules/__pycache__

		rm /Manalyze/bin/attack.py
		rm /Manalyze/bin/plot_timestamps.py
		rm /Manalyze/bin/yara_rules/parse_clamav.py
		rm /Manalyze/bin/yara_rules/update_clamav_signatures.py

		make install
	)
}

_init_yara_cache() {

	printf "%s\n" "Building application cache (blank run)"
	manalyze -p all "${MALWARE_BIN}" >/dev/null
}

manalyze_install() {

	apk add \
		git \
		python3 \
		py3-requests \
		boost-dev \
		openssl-dev \
		build-base \
		cmake

	_build_manalyze

	_clear_bad_format_yara_rules

	_init_yara_cache

	_manalyze_distroless
}
