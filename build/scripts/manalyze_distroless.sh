# This file is part of the global_install.sh script.
# It should not be executed alone.

manalyze_distroless() {

        cp_folder_to_distroless /etc/ssl
        cp_folder_to_distroless /usr/bin
        cp_folder_to_distroless /usr/local/share/manalyze
        cp_folder_to_distroless /usr/local/etc/manalyze
        cp_folder_to_distroless /root/.cache

        add_binaries_and_libs \
                manalyze.bin

        cp_files_to_distroless "/usr/local/bin/manalyze"

        cp_files_to_distroless "/etc/services"

        cp_files_to_distroless \
                "/usr/local/lib/manalyze/plugins/libplugin_virustotal.so"
        cp_files_to_distroless \
                "/usr/lib/libssl.so.3"
        cp_files_to_distroless \
                "/usr/lib/libcrypto.so.3"
        cp_files_to_distroless \
                "/usr/local/lib/manalyze/plugins/libplugin_authenticode.so"
}

