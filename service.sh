MODDIR="${0%/*}"
. "${MODDIR}/common/functions.sh"

# Wait for the key press until the system boot is comleted
# check every second 
until [[ "$(resetprop sys.boot_completed)" == 1 ]]; do
  press_check 1 && disable_modules
done
