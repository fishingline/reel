source (status dirname)/includes/bootstrap.fish
setup (realpath (status filename))

source $TEST_PROJECT_DIR/functions/_reel_cmd_help.fish
set helptxt (_reel_cmd_help)
set errcode $status
set helpheader (string sub --length 6 $helptxt[1])

@test "'_reel_cmd_help' outputs usage" "$helpheader" = "reel -"
@test "'_reel_cmd_help' returns 0" $errcode -eq 0

teardown
