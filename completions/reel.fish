complete -c reel -x -s h -l help -d 'Display help and exit'
complete -c reel -x -s v -l version -d 'Display version and exit'
complete -c reel -x -n __fish_use_subcommand -a ls -d 'List installed plugins'
complete -c reel -x -n __fish_use_subcommand -a in -d 'Initialize plugins (clone and load)'
complete -c reel -x -n __fish_use_subcommand -a rm -d 'Remove an existing plugin'
complete -c reel -x -n __fish_use_subcommand -a up -d 'Update plugins'
complete -c reel -x -n __fish_use_subcommand -a clone -d 'Clone a plugin'
complete -c reel -x -n __fish_use_subcommand -a load -d 'Load a plugin'

complete -c reel -x -n '__fish_seen_subcommand_from rm' -a "(reel ls)"
complete -c reel -x -n '__fish_seen_subcommand_from up' -a "(reel ls)"
