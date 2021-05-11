set thisfile (status filename)
set thisdir (dirname $thisfile)
@echo "=== "(basename $thisfile)" ==="

source $thisdir/includes/setup_teardown.fish

setup
reel list >/dev/null 2>&1
@test "'reel ls' command succeeds with no plugins installed" $status -eq 0
set pluginlist (reel ls)
@test "'reel ls' lists 0 plugins" (count $pluginlist) -eq 0
teardown

setup "fakes"
reel list >/dev/null 2>&1
@test "'reel ls' command succeeds" $status -eq 0
set pluginlist (reel ls)
@test "'reel ls' lists 3 fake plugins" (count $pluginlist) -eq 3
@test "1st fake plugin is $fake1" "$pluginlist[1]" = "$fake1"
@test "2nd fake plugin is $fake2" "$pluginlist[2]" = "$fake2"
@test "3rd fake plugin is $fake3" "$pluginlist[3]" = "$fake3"
teardown
