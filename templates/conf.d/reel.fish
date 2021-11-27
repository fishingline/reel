# ~/.config/fish/reel.fish
set --query reel_plugins_path || set --global reel_plugins_path $__fish_config_dir/plugins
test -d $reel_plugins_path/reel || git clone https://github.com/mattmc3/reel $reel_plugins_path/reel
set fish_complete_path $fish_complete_path[1] $reel_plugins_path/*/completions $fish_complete_path[2..]
set fish_function_path $fish_function_path[1] $reel_plugins_path/*/functions $fish_function_path[2..]
for confd in $reel_plugins_path/*/conf.d/*.fish
    builtin source "$confd"
end
