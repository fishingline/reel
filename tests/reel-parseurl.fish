set thisfile (status filename)
set thisdir (dirname $thisfile)
@echo "=== "(basename $thisfile)" ==="

source $thisdir/includes/setup_teardown.fish

setup

set -l reply (__reel_parse_giturl "mattmc3/reel")
@test "parse __reel_parse_giturl url" $reply[1] = "https://github.com/mattmc3/reel"
@test "parse __reel_parse_giturl proto" $reply[2] = "https://"
@test "parse __reel_parse_giturl host" $reply[3] = "github.com"
@test "parse __reel_parse_giturl user" $reply[4] = mattmc3
@test "parse __reel_parse_giturl repo" $reply[5] = reel

teardown
