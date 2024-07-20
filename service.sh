MODDIR="${0%/*}"
. "$MODDIR/util_functions.sh"

until [[ "$(getprop sys.boot_completed)" == '1' ]]; do
    press_check 1 && disable_modules
done
