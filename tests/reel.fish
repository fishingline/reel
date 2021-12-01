# set thisfile (status filename)
# set thisdir (dirname $thisfile)
# @echo "=== "(basename $thisfile)" ==="

# source $thisdir/includes/bootstrap.fish

# setup
# set reply (reel)
# @test "'reel' returns 1 when called with no arguments" $status -eq 1
# set reelheader (string sub -l 6 $reply[1])
# @test "'reel' replys help when called with no arguments" $reelheader = "reel -"
# set reply (reel foo 2>&1)
# @test "'reel' returns 1 when called with a bad argument" $status -eq 1
# string match -q '*unknown flag or command "foo"*' $reply[1]
# @test "'reel foo' prints 'bad command' message" $status -eq 0
# teardown
