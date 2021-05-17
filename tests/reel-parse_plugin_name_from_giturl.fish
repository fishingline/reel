set thisfile (status filename)
set thisdir (dirname $thisfile)
@echo "=== "(basename $thisfile)" ==="

set -l prjdir (realpath (status filename)/../..)
source $prjdir/functions/reel.fish

set plugin_url_to_names \
    "https://bitbucket.org/user/plugin" \
    "git://github.com/user/plugin.git" \
    "http://insecuregit.org/user/plugin" \
    "git@gitlab.com:user/plugin.git" \
    "ssh://securesite.org/user/plugin" \
    shorthand/plugin

for url in $plugin_url_to_names
    set -l plugin_name (__reel_parse_plugin_name_from_giturl $url)
    @test "$url parses plugin name correctly" $plugin_name = plugin
end
