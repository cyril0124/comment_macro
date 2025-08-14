# comment_macro

A powerful macro processor that allows embedding and executing Lua code within comments of various source files. This tool enables dynamic code generation by evaluating Lua expressions embedded in special comment blocks.

## Requirements
- xmake
- rust

## Installation
Simply run the following command:
```bash
xmake build
```
The resulting binary will be located in the `./bin` directory.

## Usage
```bash
Usage: comment_macro [OPTIONS] [FILE]...

Arguments:
  [FILE]...  

Options:
  -f, --filelist <FILELIST>  Input filelist
  -o, --outdir <OUTDIR>      Output directory
  -F, --force-enable         Force enable comment_macro(ignore the first line comment of the input file)
  -h, --help                 Print help
  -V, --version              Print version
```
