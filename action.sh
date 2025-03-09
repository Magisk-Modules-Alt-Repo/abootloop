#!/system/bin/env sh
#
# Enable all Magisk modules
MODDIR="$(dirname "${0}")"

for mod in ${MODDIR}/../*; do
  if [ -d "${mod}" ] && [ -f "${mod}/disable" ]; then
    list="${list} ${mod}/disable"
  fi
done
[ -n "${list}" ] && rm -f -- ${list}
