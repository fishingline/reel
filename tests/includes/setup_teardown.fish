function setup
    set -g TEST_TEMPDIR (mktemp -d)
    set -g reel_plugins_path "$TEST_TEMPDIR/plugins"
    set -l prjdir (get_project_dir)

    @echo "setting temp \$reel_plugins_path: $reel_plugins_path"

    set -g fake1 "a/fake1"
    set -g fake2 "b/fake2"
    set -g fake3 "b/fake3"
    if test "$argv[1]" = true || test "$argv[1]" = "fakes"
        @echo "Creating fake plugins..."
        make_fake_plugin_structure $fake1 functions
        make_fake_plugin_structure $fake2 functions conf.d
        make_fake_plugin_structure $fake3 functions conf.d completions
    end

    @echo "sourcing reel"
    source $prjdir/functions/reel.fish
end

function get_project_dir
    realpath (status filename)/../../..
end

function make_fake_plugin_structure -a name
    for dirname in $argv[2..-1]
        mkdir -p $reel_plugins_path/$name/$dirname
        set -l repo_name (string split "/" -- $name)[2]
        set -l filename $reel_plugins_path/$name/$dirname/$repo_name.fish
        switch "$dirname"
            case functions
                make_fake_plugin_function $repo_name > $filename
            case conf.d
                make_fake_plugin_confd $repo_name > $filename
            case '*'
                touch $filename
        end
    end
end

function make_fake_plugin_confd -a name
    echo "set -g loaded_plugins \$loaded_plugins $name"
end

function make_fake_plugin_function -a name
    echo "function $name"
    echo "    echo $name"
    echo "end"
end

function teardown
    test -d $TEST_TEMPDIR; or return
    if string match -q '/var/folders/*' $TEST_TEMPDIR || string match -q '/tmp/*' $TEST_TEMPDIR
        @echo "removing $TEST_TEMPDIR"
        rm -rf "$TEST_TEMPDIR"
    else
        @echo "Unexpected location for temp dir:" $TEST_TEMPDIR
    end
end
