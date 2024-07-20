fucking_array() {
    unset raz
    for var in "$@"; do
        let raz++
        eval arr${raz}=\"$var\"
    done
    limit=$((raz+1))
}

mkconfig() {
    case "$1" in
        2) config='KEY_POWER';;
        3) config='KEY_VOLUMEUP';;
        4) config='KEY_VOLUMEDOWN';;
        5) config="'(ABS_MT_POSITION_Y|ABS_MT_POSITION_X)'";;
    esac
    let configs++
    echo "action${configs}=${config}" >> $MODPATH/config.sh
}

keys() {
    timelimit="$(( $(date +%s) + 60 ))"
    unset key
    while true; do
        keys="$(timeout 0.01 getevent -lqc1 &)"
        time="$(date +%s)"
        [[ $time -gt $timelimit ]] && abort '! Timeout'
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
    list="$(for eraz in $(seq $raz); do
                echo -n ', '; eval echo -n "$(echo \$arr$eraz)"
            done)"
    ui_print ">> Avaliable options: ${list:2}."
    ui_print
    sleep 0.5
    unset i
    while true; do
        let i++
        [[ "$i" == "$limit" ]] && i=1
        one="$(eval echo -n "$(echo \$arr$i)")"
        ui_print ">>> Your choise: $one"
        keys
        [[ "$key" == 'up' ]] && break
        [[ "$key" == 'down' ]] && continue
    done
    ui_print
    [[ "$i" == '1' ]] && abort '! Installation has been aborted'
}

# main
if command -v getevent > /dev/null; then
    ui_print '- `getevent` command found'
else
    abort '! `getevent` command missing'
fi
getevent -il | grep -q 'ABS_MT_POSITION_.' || ui_print '! [Touch screen] option is not working on your device!'

if getevent -il | grep -q 'KEY_VOLUME.'; then
    ui_print '**** Configurating ****'
    ui_print 'Use [Vol+] to confirm your choice, and [Vol-] to select next option!'
    ui_print
    sleep 1
    ui_print '> Should the module use one button or a combination of buttons?'
    selector 1

    case "$i" in
        2)
            ui_print '> Select a button'
            selector 3
            mkconfig "$i"
            ;;
        3)
            a='1'
            for num in first second; do
                ui_print "> Select the ${num} combination button"
                let a++
                selector "$a"
                mkconfig "$i"
            done
            ;;
    esac
else
    ui_print '- It looks like your device does not have volume buttons'
    ui_print '- Use [Power key] to trigger the module!'
    mkconfig '2'
fi
