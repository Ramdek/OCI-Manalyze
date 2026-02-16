# OCI-Manalyze

An OCI container wrapper for [Manalyze](https://github.com/JusticeRage/Manalyze)
tool.

The image comes prepackaged with yara rules free of errors and precompiled.

## Usage

Choose your favourite container management tool. *(podman will be used in the
examples)*

### Single file analysis

By default, the container uses the following flags `-p all -o json`.  
It scans the file under `/binary` inside of the container.

```
podman run -it --rm -v /path/to/pe/binary:/binary Ramdek/manalyze
```

You can change default behaviour by calling the `manalyze` binary.

```
podman run -it --rm -v /path/to/pe/binary:/other-binary Ramdek/manalyze manalyze -p all /other-binary
```

### Directory analysis

It is possible to scan PE files in a directory.

```
podman run -it --rm -v /path/to/pe/directory:/binaries Ramdek/manalyze manalyze -p all -r /binaries
```

## Build (not yet)

You can use the Makefile to build the image:

```sh
make
```
