MODDIR=${0%/*}
. $MODDIR/util_functions.sh

until resetprop sys.boot_completed; do
    press_check && disable_modules
done
