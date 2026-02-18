# OCI-Manalyze

An OCI container wrapper for [Manalyze](https://github.com/JusticeRage/Manalyze)
tool.

The image comes prepackaged with yara rules free of errors and precompiled.

## Usage

Choose your favourite container management tool. *(podman will be used in the
examples)*

The image can be pulled like this:

```
podman pull ghcr.io/ramdek/manalyze:latest
```

### Single file analysis

By default, the container uses the following flags `-p all -o json`.  
It scans the file under `/binary` inside of the container.

```
podman run -it --rm -v /path/to/pe/binary:/binary ghcr.io/ramdek/manalyze
```

You can change default behaviour by calling the `manalyze` binary.

```
podman run -it --rm -v /path/to/pe/binary:/other-binary ghcr.io/ramdek/manalyze manalyze -p all /other-binary
```

### Directory analysis

It is possible to scan PE files in a directory.

```
podman run -it --rm -v /path/to/pe/directory:/binaries ghcr.io/ramdek/manalyze manalyze -p all -r /binaries
```

### VirusTotal

The image supports using the VirusTotal plugin.  
`VIRUS_TOTAL_API_KEY` environment variable should be filled to use it.

```
podman run -it --rm -e VIRUS_TOTAL_API_KEY=xxxx -v /path/to/pe/binary:/binary ghcr.io/ramdek/manalyze
```

## Build (not yet)

> The `noshellkit` submodule is not yet available !

You can use the Makefile to build the image:

```sh
make
```

The image `ramdek/manalyze:dev` will then be built.
