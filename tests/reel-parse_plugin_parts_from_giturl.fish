set thisfile (status filename)
set thisdir (dirname $thisfile)
@echo "=== "(basename $thisfile)" ==="

set -l prjdir (dirname (status dirname))
source $prjdir/functions/reel.fish

set plugin_url_to_names \
    "https://bitbucket.org/user/plugin" \
    "git://github.com/user/plugin.git" \
    "http://insecuregit.org/user/plugin" \
    "git@gitlab.com:user/plugin.git" \
    "ssh://securesite.org/user/plugin" \
    user/plugin

for url in $plugin_url_to_names
    set -l plugin_parts (__reel_parse_plugin_parts_from_giturl $url)
    @test "$url parses plugin gituser correctly" $plugin_parts[1] = user
    @test "$url parses plugin reponame correctly" $plugin_parts[2] = plugin
end
