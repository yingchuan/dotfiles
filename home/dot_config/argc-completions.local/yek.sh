#!/usr/bin/env bash
# Automatic generated, DON'T MODIFY IT.

# @flag --no-config                               Do not use a config file
# @option --config-file <CONFIG_FILE>             Path to the config file
# @flag -V --version                              Print version of yek
# @option --max-size <MAX_SIZE>                   Max size per chunk.
# @option --tokens                                Use token mode instead of byte mode
# @flag --json                                    Enable JSON output
# @flag --debug                                   Enable debug output
# @option --output-dir <OUTPUT_DIR>               Output directory.
# @option --output-template <OUTPUT_TEMPLATE>     Output template.
# @option --ignore-patterns* <IGNORE_PATTERNS>    Ignore patterns
# @option --unignore-patterns* <UNIGNORE_PATTERNS>  Unignore patterns.
# @flag -h --help                                 Print help
# @arg input-paths*                               Input files and/or directories to process

command eval "$(argc --argc-eval "$0" "$@")"