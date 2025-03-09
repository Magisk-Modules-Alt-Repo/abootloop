MODDIR="${0%/*}"
. "${MODDIR}/common/functions.sh"

# Wait for the key press for 3 seconds
press_check 3 && disable_modules
