# reel

[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](/LICENSE)

<img align="right"
     width="250"
     alt="reel"
     src="https://raw.githubusercontent.com/mattmc3/reel/resources/img/pexels-brent-keane-1687242.jpg">

> Reel in your fish plugins.

Simple, fast, elegant fish plugin management.

## Installation

TLDR; To `reel in` plugins, simply add this to your `fish.conf`:

```fish
# set where you want to store plugins
set reel_plugin_dir $__fish_config_dir/plugins

# get reel
if test ! -d $reel_plugin_dir/reel
    git clone --depth 1 https://github.com/mattmc3/reel $reel_plugin_dir/reel
end
```

## Introduction

Other plugin managers may require extra variables or configuration files, do a lot of
behind-the-scenes magic, require using an entire framework on top of plugin management,
or clutter up your personal fish config.

Reel doesn't do any of that. It doesn't need to. It offers a much simpler way to think
about managing your fish shell plugins. The power of Reel is that it is simple to
understand how it works, lightning fast at loading your plugins, doesn't abstract you
too far from its `git` underpinnings, and allows you to load local plugins in addition
to remote git repos.

Fish "Plugins" are simply directories that mimic the structure of the `~/.config/fish`
directory. Reel works by treating these plugins like they are directly in your fish
functions, completions, or conf.d directories. It does this by using fish's built-in
`$fish_function_path` and `$fish_complete_path` variables to tell fish where to find a
plugin's key files.

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
