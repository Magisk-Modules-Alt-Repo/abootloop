cfgpath="${MODPATH}/common/cfg.sh"
powkey='KEY_POWER'
volupkey='KEY_VOLUMEUP'
voldownkey='KEY_VOLUMEDOWN'
keylist="${powkey} ${volupkey} ${voldownkey}"

detect_keys() {
  local event
  while true; do
    event="$(getevent -lqn -c1)"
    # `KEY.*DOWN` means that the key was pressed, not released
    if echo "${event}" | grep -q "${volupkey}.*DOWN"; then
      echo 'volup' && break
    elif echo "${event}" | grep -q "${voldownkey}.*DOWN"; then
      echo 'voldown' && break
    fi
  done
}

mkcfg() {
  local count
  local key
  count="${1}"
  key="${2}"

  echo "key${count}=${key}" >> "${cfgpath}"
  ui_print ">> ${key} is selected!"
  ui_print
}

upd_complete_var() {
  echo "Complete the installation with ${1} keys selected"
}

interactive() {
  local pressed_key
  local complete
  local choice
  local count

  ui_print '**** Customizing ****'
  ui_print
  ui_print '- Use VOL+ to confirm your choice'
  ui_print '  and VOL- to select next option!'
  ui_print
  sleep 1

  count=0
  complete="$(upd_complete_var ${count})"
  
  while true; do
    for choice in ${keylist} "${complete}"; do
      ui_print "> ${choice}"
      pressed_key="$(detect_keys)"
      case "${pressed_key}" in
        volup) break;;
        voldown) continue;;  # Continue the loop if VOL- has been pressed
      esac
    done

    if [[ "${pressed_key}" == 'volup' ]]; then
      if [[ "${choice%_*}" == 'KEY' ]]; then
        # Add a new key to the conf
        count="$((count + 1))" 
        mkcfg "${count}" "${choice}"
        [[ "${count}" == 2 ]] && break  # Do not add more than 2 keys
        complete="$(upd_complete_var ${count})"
      else
        break  # Complete the installation manually
      fi
    fi
  done
}

fallback() {
  ui_print '- It looks like your device does'
  ui_print '  not have volume buttons'
  ui_print '- Use the power key to trigger the module!'
  mkcfg 1 "${powkey}"
}

main() {
  command -v getevent > /dev/null || abort '! `getevent` command missing'
  if getevent -il | grep -q 'KEY_VOLUME.'; then
    interactive
  else
    fallback
  fi
}

main
