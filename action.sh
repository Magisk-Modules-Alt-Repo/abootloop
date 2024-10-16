#!/system/bin/env sh
MODDIR="${0%/*}"

for mod in $MODDIR/../*; do
    [[ -d "$mod" && -f "$mod/disable" ]] \
    && list="$mod/disable $list"
done
rm -f $list
