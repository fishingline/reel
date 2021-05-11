set thisfile (status filename)
set thisdir (dirname $thisfile)
@echo "=== "(basename $thisfile)" ==="

source $thisdir/includes/setup_teardown.fish

setup fakes

@echo "--- remove single plugin ---"
@test "$fake1 plugin exists" -d $reel_plugins_path/$fake1
reel rm $fake1 >/dev/null 2>&1
@test "'reel rm $fake1' command succeeds" $status -eq 0
@test "$fake1 plugin no longer exists" ! -d $reel_plugins_path/$fake1
@test 'no other plugins were harmed' -d $reel_plugins_path/$fake2

@echo "--- remove with no plugin specified ---"
set reply (reel rm 2>&1)
@test "'reel rm' command fails" $status -eq 1
@test "'reel rm' replies with arg expected" "$reply" = "reel: plugin argument expected"

@echo "--- remove tricky directory ---"
set tricky_dir (mktemp -d)
@test "tricky dir is available as relative path from \$reel_plugins_path" -d $reel_plugins_path/../../(basename $tricky_dir)
set tricky_plugin "../../"(basename $tricky_dir)
@echo "try to remove tricky dir: $tricky_plugin"
set reply (reel rm $tricky_plugin 2>&1)
@test "'reel rm $tricky_plugin' fails" $status -eq 1
string match -q 'reel: plugin path not safe to remove*' $reply[1]
@test "'reel rm $tricky_plugin' replies with not safe" $status -eq 0
rm -rf $tricky_dir

@echo "--- remove multiple plugins ---"
@test "$fake2 plugin exists" -d $reel_plugins_path/$fake2
@test "$fake3 plugin exists" -d $reel_plugins_path/$fake3
reel rm $fake2 $fake3 >/dev/null 2>&1
@test "'reel rm $fake2 $fake3' command succeeds" $status -eq 0
@test "$fake2 plugin no longer exists" ! -d $reel_plugins_path/$fake2
@test "$fake3 plugin no longer exists" ! -d $reel_plugins_path/$fake3

@echo "--- remove non-existent plugins ---"
reel rm nonexistent >/dev/null 2>&1
@test "'reel rm nonexistent' command fails" $status -ne 0
teardown
