. "$MODDIR/config.sh"

press_check() {
    if [[ -n "$action2" ]]; then
        echo "$(timeout $1 getevent -lqn)" | grep -qE "${action1}.*${action2}|${action2}.*${action1}"
    else
        timeout $1 getevent -lq | grep -q "$action1"
    fi
}

disable_modules() {
    for mod in $MODDIR/../*; do
        touch "$mod/disable"
    done
    reboot
}
