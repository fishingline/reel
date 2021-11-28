# reel

[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](/LICENSE)

<img align="right"
     width="250"
     alt="reel"
     src="https://raw.githubusercontent.com/mattmc3/reel/resources/img/pexels-brent-keane-1687242.jpg">

> Reel in your fish plugins.

Simple, fast, elegant fish plugin management.

## Fish plugin support

TLDR; To start using reel to manage your fish plugins, simply add this bootstrap snippet
to your `fish.conf` file:

```fish
set -q reel_plugins_path; or set -g reel_plugins_path $__fish_config_dir/plugins
test -d $reel_plugins_path/reel; \
    or git clone https://github.com/mattmc3/reel $reel_plugins_path/reel
test -f $reel_plugins_path/reel/lib/bootstrap.fish; \
    and source $reel_plugins_path/reel/lib/bootstrap.fish
```

## Introduction

Other plugin managers do all sorts of fancy magic to manage your Fish plugins. They
clutter up your fish config, or they only manage certain plugins or certain git
providers.

Reel doesn't do any of that. It offers a much simpler way to think about managing your
fish shell plugins. The power of Reel is that:

- Reel is lightning fast at loading your plugins
- Reel feels like it could have easily been built-in to fish itself
- Reel has a readable, easy to understand codebase
- Reel doesn't mingle plugins with your personal fish files
- Reel doesn't clutter your `~/.config/fish`, and can easily be configured to use
  a different plugin location
- Reel lets you easily share your plugin configuration across systems
- Reel doesn't abstract you too far from its `git` underpinnings
- Reel is extensively unit tested with [Fishtape][fishtape] to ensure it is reliable
- Reel allows you to load all sorts of fish plugins:
  - Plugins from providers other than GitHub (BitBucket, GitLab, etc)
  - Plugins from a specified git branch, not just 'main'
  - Plugins from local directories
  - Plugins you chose to install manually without using Reel
  - Plugins that use git submodules
  - Plugins that use 'install', 'update', or 'uninstall' events
  - Plugins designed to override or extend other plugins
  - Plugins you are developing yourself

Fish "Plugins" are simply directories that mimic the structure of `~/.config/fish`. Reel
works by treating any subdirectory you add to `~.config/fish/plugins` like it is part of
your fish config. It does this simply by using fish's built-in `$fish_function_path` and
`$fish_complete_path` variables to tell fish where to find your plugin's key files, and
sourcing files in the plugin's `conf.d`.

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

[fishtape]: https://github.com/jorgebucaran/fishtape/
