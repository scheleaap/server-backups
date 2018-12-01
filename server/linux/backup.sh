#!/bin/bash
# ARG_OPTIONAL_BOOLEAN([quiet],[q],[Supress informational messages and warnings])
# ARG_POSITIONAL_SINGLE([globinclude_file],[Include file])
# ARG_POSITIONAL_SINGLE([globexclude_file],[Exclude file])
# ARG_HELP([Create backups with rdiff-backup. Example: backup.sh globinclude.list globexclude.list])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.6.1 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate

die()
{
    local _ret=$2
    test -n "$_ret" || _ret=1
    test "$_PRINT_HELP" = yes && print_help >&2
    echo "$1" >&2
    exit ${_ret}
}

begins_with_short_option()
{
    local first_option all_short_options
    all_short_options='qh'
    first_option="${1:0:1}"
    test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}



# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_quiet="off"

print_help ()
{
    printf '%s\n' "Create backups with rdiff-backup. Example: backup.sh globinclude.list globexclude.list"
    printf 'Usage: %s [-q|--(no-)quiet] [-h|--help] <globinclude_file> <globexclude_file>\n' "$0"
    printf '\t%s\n' "<globinclude_file>: Include file"
    printf '\t%s\n' "<globexclude_file>: Exclude file"
    printf '\t%s\n' "-q,--quiet,--no-quiet: Supress informational messages and warnings (off by default)"
    printf '\t%s\n' "-h,--help: Prints help"
}

parse_commandline ()
{
    while test $# -gt 0
    do
        _key="$1"
        case "$_key" in
            -q|--no-quiet|--quiet)
                _arg_quiet="on"
                test "${1:0:5}" = "--no-" && _arg_quiet="off"
                ;;
            -q*)
                _arg_quiet="on"
                _next="${_key##-q}"
                if test -n "$_next" -a "$_next" != "$_key"
                then
                    begins_with_short_option "$_next" && shift && set -- "-q" "-${_next}" "$@" || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
                fi
                ;;
            -h|--help)
                print_help
                exit 0
                ;;
            -h*)
                print_help
                exit 0
                ;;
            *)
                _positionals+=("$1")
                ;;
        esac
        shift
    done
}


handle_passed_args_count ()
{
    _required_args_string="'globinclude_file' and 'globexclude_file'"
    test ${#_positionals[@]} -ge 2 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require exactly 2 (namely: $_required_args_string), but got only ${#_positionals[@]}." 1
    test ${#_positionals[@]} -le 2 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect exactly 2 (namely: $_required_args_string), but got ${#_positionals[@]} (the last one was: '${_positionals[*]: -1}')." 1
}

assign_positional_args ()
{
    _positional_names=('_arg_globinclude_file' '_arg_globexclude_file' )

    for (( ii = 0; ii < ${#_positionals[@]}; ii++))
    do
        eval "${_positional_names[ii]}=\${_positionals[ii]}" || die "Error during argument parsing, possibly an Argbash bug." 1
    done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash

set -o nounset
set -o errexit

prog=$(basename $0)

lock=/var/lock/${prog}.pid
backup_source="/"
#backup_target="${dest_userhost}::${dest_path}"
backup_target="/var/backup/data"
binary=$(which rdiff-backup)

if [ "${binary}" == "" ]; then
    >&2 echo "Error: rdiff-backup not found"
    exit 1
fi

if [ "$_arg_quiet" == "off" ]; then
    echo "Lock file: $lock"
    echo "Binary: $binary"
    echo "Backup source: ${backup_source}"
    echo "Backup target: ${backup_target}"
fi

if [ -e $lock ]
then
        pid=$(cat $lock)
        if kill -CHLD $pid
        then
                echo >&2 "Process already running"
                exit 0
        else
                if [ "$_arg_quiet" == "off" ]; then
                    echo "Stale proccess ($pid) detected, continue"
                fi
        fi
#else
#       echo "geen lock, dus backuppen maar"
fi

echo $$ > $lock

if [ "$_arg_quiet" == "off" ]; then
    verbosity=3
    print_statistics="--print-statistics"
else
    verbosity=2
    print_statistics=""
fi
cmd="$binary -v${verbosity} ${print_statistics} --exclude-special-files --include-globbing-filelist $_arg_globinclude_file --exclude-globbing-filelist $_arg_globexclude_file ${backup_source} ${backup_target}"

if [ "$_arg_quiet" == "off" ]; then
    echo "Starting backup"
fi

#echo $cmd
$cmd

#$binary -v${verbosity} --force --remove-older-than 4W ${backup_target}

/bin/rm -f $lock

if [ "$_arg_quiet" == "off" ]; then
    echo "Backup finished"
fi

# ] <-- needed because of Argbash
