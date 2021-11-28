source (status dirname)/includes/setup_teardown.fish
setup (realpath (status filename))

source $TEST_PROJECT_DIR/functions/_reel_plugin_info.fish

@echo "--- plugin info for mattmc3/reel ---"
set reply (_reel_plugin_info mattmc3/reel 2>&1)
@test "'_reel_plugin_info' echos 3 lines" (count $reply) -eq 3
@test "'_reel_plugin_info' giturl is https://github.com/mattmc3/reel.git" "$reply[1]" = "https://github.com/mattmc3/reel.git"
@test "'_reel_plugin_info' name is reel" "$reply[2]" = reel
@test "'_reel_plugin_info' type is giturl" "$reply[3]" = giturl

@echo "--- plugin info for ~/Projects/myplugin ---"
set reply (_reel_plugin_info '~/Projects/myplugin' 2>&1)
@test "'_reel_plugin_info' echos 3 lines" (count $reply) -eq 3
@test "'_reel_plugin_info' path is $HOME/Projects/myplugin" "$reply[1]" = "$HOME/Projects/myplugin"
@test "'_reel_plugin_info' name is myplugin" "$reply[2]" = myplugin
@test "'_reel_plugin_info' type is local" "$reply[3]" = local

@echo "--- plugin info for '' ---"
set reply (_reel_plugin_info '' 2>&1)
set errcode $status
@test "'_reel_plugin_info' echos 0 lines" (count $reply) -eq 0
@test "'_reel_plugin_info' returns 1" $errcode -eq 1

teardown
