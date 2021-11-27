function _reel_cmd_help \
    --description "Print out reel help information"

    echo "reel - Reel in your fish plugins"
    echo ""
    echo "Usage:"
    echo "  reel [-h|--help]"
    echo "  reel [-v|--version]"
    echo "  reel <command> [<args>...]"
    echo ""
    echo "Commands:"
    echo ""
    echo "  reel in <plugins...>    Install plugin(s)"
    echo "  reel up <plugins...>    Update plugin(s)"
    echo "  reel rm <plugins...>    Remove plugin(s)"
    echo "  reel ls [--style=xxx]   List plugins (styles: name, repo, path, url)"
    echo "  reel load               Load a single directory as a plugin"
end
