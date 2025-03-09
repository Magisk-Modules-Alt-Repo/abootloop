. "${MODDIR}/common/cfg.sh"  # Get selected keys

press_check() {
  timeout "${1}" getevent -lqn | grep -qE "${key1}.*${key2}|${key2}.*${key1}"
}

disable_modules() {
  local list
  for mod in ${MODDIR}/../*; do
    if [[ -d "${mod}" && ! -f "${mod}/disable" ]]; then
      list="${list} ${mod}/disable"
    fi
  done
  [[ -n "${list}" ]] && touch ${list}
  reboot
}
