fucking_array() {
    unset raz
    for var in "$@"; do
        let raz++
        eval arr${raz}=\"$var\"
    done
    limit=$((raz + 1))
}

mkconfig() {
    case "$1" in
        2) config='KEY_POWER';;
        3) config='KEY_VOLUMEUP';;
        4) config='KEY_VOLUMEDOWN';;
        5) config="'(ABS_MT_POSITION_Y|ABS_MT_POSITION_X)'";;
    esac
    let configs++
    echo "action${configs}=${config}" >> "$MODPATH/config.sh"
}

keys() {
    timelimit="$(( $(date +%s) + 60 ))"
    while true; do
        keys="$(timeout 0.01 getevent -lqc1 &)"
        time="$(date +%s)"
        [[ "$time" -gt "$timelimit" ]] && abort '! Timeout'
        if echo "$keys" | grep -q 'KEY_VOLUMEUP.*DOWN'; then
            key='up'; break
        elif echo "$keys" | grep -q 'KEY_VOLUMEDOWN.*DOWN'; then
            key='down'; break
        fi
    done
}

selector() {
    case "$1" in
        1) fucking_array '[Abort installation]' '[One button]' '[Button combination]';;
        2) fucking_array '[Abort installation]' '[Power key]' '[Vol+]' '[Vol-]' '[Touch screen]';;
        3) fucking_array '[Abort installation]' '[Power key]' '[Vol+]' '[Vol-]';;
    esac
    ui_print ">> Avaliable options:"
    for eraz in $(seq "$raz"); do
        eval ui_print \" ' ' $(echo \$arr$eraz)\"
    done
    ui_print
    sleep 0.5
    i='1'
    while true; do
        let i++
        [[ "$i" == "$limit" ]] && i='1'
        one="$(eval echo -n "$(echo "\$arr$i")")"
        ui_print ">>> Your choice: $one"
        keys
        [[ "$key" == 'up' ]] && break
        [[ "$key" == 'down' ]] && continue
    done
    ui_print
    [[ "$i" == '1' ]] && abort '! Installation has been aborted'
    [[ "$1" != '1' ]] && mkconfig "$i"
}

# main
command -v getevent > /dev/null || abort '! `getevent` command missing'
if ! getevent -il | grep -q 'ABS_MT_POSITION_.'; then
    ui_print '! [Touch screen] option is'
    ui_print '  not working on your device!'
    sleep 1
fi

if getevent -il | grep -q 'KEY_VOLUME.'; then
    ui_print '**** Customizing ****'
    ui_print '- Use [Vol+] to confirm your choice,'
    ui_print '  and [Vol-] to select next option!'
    ui_print
    sleep 1
    ui_print '> Should the module use one button'
    ui_print '  or a combination of buttons?'
    selector 1

    case "$i" in
        2)
            ui_print '> Select a button'
            selector 3
            ;;
        3)
            ui_print '> Select the first combination button'
            selector 2
            ui_print '> Select the second combination button'
            selector 3
            ;;
    esac
else
    ui_print '- It looks like your device does'
    ui_print '  not have volume buttons'
    ui_print '- Use [Power key] to trigger the module!'
    mkconfig 2
fi
