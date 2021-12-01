function _bootstrap_test_framework
    set fish_function_path $fish_function_path[1] \
                           (realpath (status dirname)/../functions) \
                           $fish_function_path[2..]
end
_bootstrap_test_framework
