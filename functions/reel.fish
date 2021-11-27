function reel \
    --description 'Reel in your fish plugins' \
    --argument-names cmd

    if test -z "$cmd"
        echo >&2 "reel: Command expected. (see `reel -h`)" && return 1
    end
    # hangle command aliases
    switch "$cmd"
        case -h --help
            set cmd help
        case -v --version
            set cmd version
        case ls
            set cmd list
        case up
            set cmd update
        case rm
            set cmd remove
        case in init
            set cmd install
    end
    if functions -q _reel_cmd_$cmd
        _reel_cmd_$cmd $argv[2..]
        return $status
    else
        echo >&2 "reel: Unknown flag or command '$argv[1]'. (see `reel -h`)" && return 1
    end
end
