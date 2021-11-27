function reel -a cmd -d 'Reel in your fish plugins'
    if test -z "$cmd"
        echo >&2 "reel: Command expected. (see `reel -h`)" && return 1
    end
    switch "$cmd"
        case -h --help
            set cmd help
        case -v --version
            set cmd version
        case ls
            set cmd list
        case rm
            set cmd remove
        case up
            set cmd update
        case in
            set cmd install
    end
    if functions -q _reel_$cmd
        _reel_$cmd $argv[2..]
        return $status
    else
        echo >&2 "reel: Unknown flag or command '$cmd'. (see `reel -h`)" && return 1
    end
end
