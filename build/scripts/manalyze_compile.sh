# This file is part of the global_install.sh script.
# It should not be executed alone.

_build_manalyze() {

	printf "%s\n" "Building Manalyze"

	(
		cd Manalyze
		cmake .
		make -j 5

		printf "%s\n" "Generating clamav signatures"
		/Manalyze/bin/yara_rules/update_clamav_signatures.py

		if [[ -z "${KEEP_PYTHON:-}" ]]; then
			printf "%s\n" "Removing python files (cache & bin utils)"
			rm -rf /Manalyze/bin/yara_rules/__pycache__

			rm /Manalyze/bin/attack.py
			rm /Manalyze/bin/plot_timestamps.py
			rm /Manalyze/bin/yara_rules/parse_clamav.py
			rm /Manalyze/bin/yara_rules/update_clamav_signatures.py
		fi

		make install
	)
}

manalyze_compile() {

	apk add \
		git \
		python3 \
		py3-requests \
		boost-dev \
		openssl-dev \
		build-base \
		cmake

	_build_manalyze
}
