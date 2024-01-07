press_check(){
    timeout 1 getevent -l | grep 'KEY_POWER'
}

disable_modules(){
    find $MODDIR/../* -maxdepth 0 -type d -exec touch '{}/disable' \;
    reboot
}
