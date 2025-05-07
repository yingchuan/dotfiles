#!/usr/bin/env bash
# Automatic generated, DON'T MODIFY IT.

# @flag -h --help       Print help
# @flag -V --version    Print version

# {{ rbw config
# @cmd Get or set configuration options
# @flag -h --help    Print help
config() {
    :;
}

# {{{ rbw config show
# @cmd Show the values of all configuration settings
# @flag -h --help    Print help
config::show() {
    :;
}
# }}} rbw config show

# {{{ rbw config set
# @cmd Set a configuration option
# @flag -h --help    Print help
# @arg key!          Configuration key to set
# @arg value!        Value to set the configuration option to
config::set() {
    :;
}
# }}} rbw config set

# {{{ rbw config unset
# @cmd Reset a configuration option to its default
# @flag -h --help    Print help
# @arg key!          Configuration key to unset
config::unset() {
    :;
}
# }}} rbw config unset
# }} rbw config

# {{ rbw register
# @cmd Register this device with the Bitwarden server
# @flag -h --help    Print help (see a summary with '-h')
register() {
    :;
}
# }} rbw register

# {{ rbw login
# @cmd Log in to the Bitwarden server
# @flag -h --help    Print help
login() {
    :;
}
# }} rbw login

# {{ rbw unlock
# @cmd Unlock the local Bitwarden database
# @flag -h --help    Print help
unlock() {
    :;
}
# }} rbw unlock

# {{ rbw unlocked
# @cmd Check if the local Bitwarden database is unlocked
# @flag -h --help    Print help
unlocked() {
    :;
}
# }} rbw unlocked

# {{ rbw sync
# @cmd Update the local copy of the Bitwarden database
# @flag -h --help    Print help
sync() {
    :;
}
# }} rbw sync

# {{ rbw list
# @cmd List all entries in the local Bitwarden database [aliases: ls]
# @option --fields    Fields to display.
# @flag -h --help     Print help
list() {
    :;
}
# }} rbw list

# {{ rbw get
# @cmd Display the password for a given entry
# @option --folder         Folder name to search in
# @option -f --field       Field to get
# @flag --full             Display the notes in addition to the password
# @flag --raw              Display output as JSON
# @flag --clipboard        Copy result to clipboard
# @flag -i --ignorecase    Ignore case
# @flag -h --help          Print help
# @arg needle!             Name, URI or UUID of the entry to display
# @arg user                Username of the entry to display
get() {
    :;
}
# }} rbw get

# {{ rbw search
# @cmd Search for entries
# @option --folder    Folder name to search in
# @flag -h --help     Print help
# @arg term!          Search term to locate entries
search() {
    :;
}
# }} rbw search

# {{ rbw code
# @cmd Display the authenticator code for a given entry [aliases: totp]
# @option --folder         Folder name to search in
# @flag --clipboard        Copy result to clipboard
# @flag -i --ignorecase    Ignore case
# @flag -h --help          Print help
# @arg needle!             Name, URI or UUID of the entry to display
# @arg user                Username of the entry to display
code() {
    :;
}
# }} rbw code

# {{ rbw add
# @cmd Add a new password to the database
# @option --uri       URI for the password entry
# @option --folder    Folder for the password entry
# @flag -h --help     Print help (see a summary with '-h')
# @arg name!          Name of the password entry
# @arg user           Username for the password entry
add() {
    :;
}
# }} rbw add

# {{ rbw generate
# @cmd Generate a new password [aliases: gen]
# @option --uri             URI for the password entry
# @option --folder          Folder for the password entry
# @flag --no-symbols        Generate a password with no special characters
# @flag --only-numbers      Generate a password consisting of only numbers
# @flag --nonconfusables    Generate a password without visually similar characters (useful for passwords intended to be written down)
# @flag --diceware          Generate a password of multiple dictionary words chosen from the EFF word list.
# @flag -h --help           Print help (see a summary with '-h')
# @arg len!                 Length of the password to generate
# @arg name                 Name of the password entry
# @arg user                 Username for the password entry
generate() {
    :;
}
# }} rbw generate

# {{ rbw edit
# @cmd Modify an existing password
# @option --folder         Folder name to search in
# @flag -i --ignorecase    Ignore case
# @flag -h --help          Print help (see a summary with '-h')
# @arg name!               Name or UUID of the password entry
# @arg user                Username for the password entry
edit() {
    :;
}
# }} rbw edit

# {{ rbw remove
# @cmd Remove a given entry [aliases: rm]
# @option --folder         Folder name to search in
# @flag -i --ignorecase    Ignore case
# @flag -h --help          Print help
# @arg name!               Name or UUID of the password entry
# @arg user                Username for the password entry
remove() {
    :;
}
# }} rbw remove

# {{ rbw history
# @cmd View the password history for a given entry
# @option --folder         Folder name to search in
# @flag -i --ignorecase    Ignore case
# @flag -h --help          Print help
# @arg name!               Name or UUID of the password entry
# @arg user                Username for the password entry
history() {
    :;
}
# }} rbw history

# {{ rbw lock
# @cmd Lock the password database
# @flag -h --help    Print help
lock() {
    :;
}
# }} rbw lock

# {{ rbw purge
# @cmd Remove the local copy of the password database
# @flag -h --help    Print help
purge() {
    :;
}
# }} rbw purge

# {{ rbw stop-agent
# @cmd Terminate the background agent
# @flag -h --help    Print help
stop-agent() {
    :;
}
# }} rbw stop-agent

# {{ rbw gen-completions
# @cmd Generate completion script for the given shell
# @flag -h --help    Print help
# @arg shell![bash|elvish|fish|powershell|zsh]
gen-completions() {
    :;
}
# }} rbw gen-completions

command eval "$(argc --argc-eval "$0" "$@")"