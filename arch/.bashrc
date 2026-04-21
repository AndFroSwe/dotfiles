#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

## Andfro
# Aliases
alias ll='ls -al'

# Update the path
export PATH=$PATH:~/.local/bin

# Add color to kitty
case "$TERM" in xterm-color | *-256color | xterm-kitty) color_prompt=yes ;; esac

# Get Better PS1
# only do this if a WM instance is running
if [ -n "${HYPRLAND_INSTANCE_SIGNATURE}" ]; then
  eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/andfro.omp.json)"
fi

# Helper for inspecting asm 
asm_pretty() {
  llvm-cxxfilt |
  sed "/DEBUG_/d" |
  sed "/\.Ltmp/d" |
  perl -pe '
    s{(/[^ \t:]+)}{
      my $path = $1;
      my $r = qx(realpath \Q$path\E 2>/dev/null);
      chomp $r;
      $r || $path
    }ge
  '
}

asm_compile() {
    # defaults
    local default_compiler="clang"
    local default_opt="2"
    local usage_string="Usage: asm_compile [-O<opt_flag>] [-c<compiler>] [-f<flags>] [-n] <filename>
  opt_flag:  Optimization level to use. Default: use compile_commands.json or -O$default_opt
  compiler:  Compiler to use. Default: $default_compiler
  flags:     Misc compiler flags to add. Use at own risk. Default: 
  -n:        Dry run — print the command instead of running it"

    OPTIND=1 # reset getopts

    # set defaults
    local input_compiler=""
    local input_opt_level=""
    local dry_run=false
    local input_flags=""

    # parse optional flags
    while getopts "c:O:f:n" opt; do
        case "$opt" in
            c) input_compiler="$OPTARG" ;;
            O) input_opt_level="$OPTARG" ;;
            f) input_flags="$OPTARG" ;;
            n) dry_run=true ;;
            ?)
                echo "Error: unknown flag." >&2
                echo "$usage_string" >&2
                return 1
                ;;
        esac
    done

    # shift past all parsed flags, leaving only positional arguments
    shift $((OPTIND - 1))

    # check that exactly one positional argument (the filename) remains
    if [ $# -ne 1 ]; then
        echo "Error: expected a filename as input." >&2
        echo "$usage_string" >&2
        return 1
    fi

    local input_file="$1"

    # check for compile db
    local compile_db="compile_commands.json"
    if [ ! -f "$compile_db" ]; then
        echo "Error: $compile_db not found." >&2
        return 1
    fi

    # check that jq is installed
    if ! command -v jq > /dev/null 2>&1; then
        echo "Error: jq not installed." >&2
        return 1
    fi

    # parse compile_commands and find the command
    local compile_command
    compile_command=$(jq -r --arg file "$input_file" '.[] | select(.file | endswith("/" + $file)) | .command' "$compile_db")

    if [ -z "$compile_command" ]; then
        echo "Error: no entry found for '$input_file' in $compile_db." >&2
        return 1
    fi

    # parse the command string
    local compiler=""
    local includes=""
    local debug_flag=""
    local output_file=""
    local c_flag=""
    local opt_flag=""
    local other_flags=""
    local first=1
    local skip=0
    local token

    set -- $compile_command
    while [ $# -gt 0 ]; do
        token="$1"

        if [ $first -eq 1 ]; then
            compiler="$token"
            first=0
        elif [ $skip -eq 1 ]; then
            skip=0
        elif echo "$token" | grep -q '^-I'; then
            includes="$includes $token"
        elif [ "$token" = "-o" ]; then
            output_file="$2"
            skip=1
        elif [ "$token" = "-g" ]; then
            debug_flag="-g"
        elif [ "$token" = "-c" ]; then
            c_flag="-c"
        elif echo "$token" | grep -q '^-O'; then
            opt_flag="$token"
        else
            other_flags="$other_flags $token"
        fi

        shift
    done

    # handle user overrides
    if [ -n "$input_compiler" ]; then
        compiler="$input_compiler"
    fi

    # scrub flags that are invalid for clang
    if [ "$compiler" = "clang" ] || [ "$compiler" = "clang++" ]; then
        other_flags=$(echo "$other_flags" | sed \
            -e 's/-fmodules-ts//g' \
            -e 's/-fmodule-mapper=[^ ]*//g' \
            -e 's/-fdeps-format=[^ ]*//g')
    fi

    # set opt flag — user override > compile_commands > default
    if [ -n "$input_opt_level" ]; then
        opt_flag="-O$input_opt_level"
    elif [ -z "$opt_flag" ]; then
        opt_flag="-O$default_opt"
    fi

    # trim leading spaces
    includes="${includes# }"
    other_flags="${other_flags# }"

    # assemble new command
    local asm_flags="-S -g"
    local new_output="-o -"
    local cmd="$compiler $asm_flags $opt_flag $includes $other_flags $input_flags $new_output"

    # execute or dry run
    if [ "$dry_run" = "true" ]; then
        echo "Compiler:    $compiler"
        echo "Includes:    $includes"
        echo "Debug flag:  $debug_flag"
        echo "Opt flag:    $opt_flag"
        echo "Other flags: $other_flags"
        echo ""
        echo "New command: $cmd"
    else
        printf '%s\n' "$cmd"
    fi
}
