# reel

[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](/LICENSE)

<img align="right"
     width="250"
     alt="reel"
     src="https://raw.githubusercontent.com/mattmc3/reel/resources/img/pexels-brent-keane-1687242.jpg">

> Reel in your fish plugins.

Simple, fast, elegant fish plugin management.

## Fish plugin support

TLDR; To start using fish plugins, simply add this to your `fish.conf`, or to a
`~/.config/fish/reel.fish` file:

```fish
# ~/.config/fish/reel.fish
set --query reel_plugins_path || set --global reel_plugins_path $__fish_config_dir/plugins
test -d $reel_plugins_path/reel || git clone https://github.com/mattmc3/reel $reel_plugins_path/reel
set fish_complete_path $fish_complete_path[1] $reel_plugins_path/*/completions $fish_complete_path[2..]
set fish_function_path $fish_function_path[1] $reel_plugins_path/*/functions $fish_function_path[2..]
for confd in $reel_plugins_path/*/conf.d/*.fish
    builtin source "$confd"
end
```

## Introduction

Other plugin managers do all sorts of fancy magic to manage your Fish plugins. They
require extra variables or configuration, they clutter up your fish config, and they
limit the kinds of plugins they manage to just git repos (and some even limit you to
just GitHub repos).

Reel doesn't do any of that. It offers a much simpler way to think about managing your
fish shell plugins. The power of Reel is that:
- Reel is simple to understand
- Reel is lightning fast at loading your plugins
- Reel doesn't abstract you too far from its `git` underpinnings
- Reel allows you to load plugins from providers other than GitHub
- Reel even alows you to use local directories as plugins

Fish "Plugins" are simply directories that mimic the structure of `~/.config/fish`. Reel
works by treating any subdirectory you add to `~.config/fish/plugins` like it is part of
your fish functions, completions, or conf.d directories. It does this simply by using
fish's built-in `$fish_function_path` and `$fish_complete_path` variables to tell fish
where to find a plugin's key files.

You can use Reel to manage all your plugins, or you can do some yourself via `git`
commands or symlinks. As long as the directories are in `~.config/fish/plugins`, reel
will pick them up.

## Reel commands

Initialize your all your plugins with `reel in`. Reel will attempt to `git clone`
plugins if they are not found.

```fish
reel in
```

Additionally, you can `reel in` a specific plugin by providing an argument:

```fish
reel in mattmc3/reel
```

You can also `reel in` a local plugin from a location on your computer by providing a
path to that plugin:

```fish
reel in ~/Projects/my-plugins/helloworld
reel in $__fish_config_dir/my-plugins/helloworld
```

You can list your plugins with `reel ls`:

```fish
reel ls
```

You can update all your remote git plugins with `reel up`:

```fish
reel up
```

Or, you can update a specific plugin:

```fish
reel up mattmc3/reel
```

Or, just use the short name

```fish
reel up reel
```

You can remove a plugin with `reel rm`:

```fish
reel rm jorgebucaran/fisher
```

Clone a plugin without loading it. github.com is the assumed home of the plugin:

```fish
reel clone laughedelic/fish_logo
```

Clone a plugin from someplace other than github.com:

```fish
reel clone git@gitlab.com:my_username/my_fish_plugin.git
reel clone https://bitbucket.org/my_other_username/my_other_fish_plugin.git
```

## Customization

Don't care for github.com? Do you want reel to use another server as the default git
domain? Set the `$reel_git_default_domain` variable at the top of your
`~/.config/fish/conf.d/reel.fish` file.

```fish
set -g reel_git_default_domain "bitbucket.org"
# or...
set -g reel_git_default_domain "gitlab.com"
```
