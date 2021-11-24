set thisfile (status filename)
set thisdir (dirname $thisfile)
@echo "=== "(basename $thisfile)" ==="

set -l prjdir (dirname (status dirname))
source $prjdir/functions/reel.fish

set giturls \
    "https://bitbucket.org/user/repo" \
    "git://github.com/user/repo.git" \
    "http://insecuregit.org/user/repo" \
    "git@gitlab.com:user/repo.git" \
    "ssh://securesite.org/user/repo"

set non_giturls \
    "ssl://bitbucket.org/user/repo" \
    "file:///usr/local/bin/fish" \
    user/repo \
    repo

for url in $giturls
    @test "$url is a git URL" (__reel_is_giturl $url) $status -eq 0
end

for url in $non_giturls
    @test "$url is a not a git URL" (__reel_is_giturl $url) $status -ne 0
end
