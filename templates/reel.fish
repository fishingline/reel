# ~/.config/fish/conf.d/reel.fish

# get reel if we don't have it
if not test -d $__fish_config_dir/plugins/mattmc3/reel
    git clone --depth 1 https://github.com/mattmc3/reel $__fish_config_dir/plugins/mattmc3/reel
end

# make the reel function available
contains $__fish_config_dir/plugins/mattmc3/reel/functions $fish_function_path
or set fish_function_path $__fish_config_dir/plugins/mattmc3/reel/functions $fish_function_path

# store your plugins in a fish_plugins list for ease, order matters
set fish_plugins \
    mattmc3/reel \
    # mattmc3/up.fish \
    # decors/fish-colored-man \
    # edc/bass \
    # jethrokuan/z
    # oh-my-fish/plugin-bang-bang
    # rafaelrinaldi/pure \
    laughedelic/fish_logo

# reel in (clone+load) your plugins
reel in $fish_plugins
