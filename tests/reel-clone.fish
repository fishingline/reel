# set thisfile (status filename)
# set thisdir (dirname $thisfile)
# @echo "=== "(basename $thisfile)" ==="

# source $thisdir/includes/setup_teardown.fish

# setup
# set cmd "reel clone"
# @echo "--- $cmd ---"
# set reply (reel clone 2>&1)
# @test "'$cmd' (with no args) reports failure" $status -eq 1
# @test "'$cmd' replies that arg expected" "$reply" = "reel: argument expected"

# set cmd "reel clone mattmc3/reel"
# @echo "--- $cmd ---"
# @test "'$cmd' reel directory does not exist yet" ! -d "$reel_plugins_path/reel"
# set reply (reel clone mattmc3/reel 2>&1)
# @test "'$cmd' reports success" $status -eq 0
# @test "'$cmd' creates reel directory in \$reel_plugins_path" -d "$reel_plugins_path/mattmc3/reel"

# teardown
