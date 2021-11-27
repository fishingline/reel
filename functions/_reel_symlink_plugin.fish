function _reel_symlink_plugin \
    --description "Symlink a plugin" \
    --argument-names source_dir dest_dir

    if not test -d $source_dir
        echo >&2 "reel: Invalid directory plugin '$source_dir'." && return 1
    else if test -d $dest_dir
        echo >&2 "reel: A plugin with that name already exists '$dest_dir'." && return 1
    end
    echo "Symlinking plugin $source_dir..."
    ln -s $source_dir $dest_dir
end
