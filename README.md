# Anti bootloop
[![](https://img.shields.io/github/downloads/Magisk-Modules-Alt-Repo/abootloop/total?logo=GitHub)](https://github.com/Magisk-Modules-Alt-Repo/abootloop/releases)
[![](https://img.shields.io/github/license/Magisk-Modules-Alt-Repo/abootloop)](https://github.com/Magisk-Modules-Alt-Repo/abootloop/blob/main/LICENSE)

Bootloop protection\
The module works in both `late_start` and `post-fs-data` modes

## Usage
### General
Customize your button combination on module installation\
and press it in case of bootloop to disable all Magisk modules

#### Button combination examples:
- [Vol+] + [Power key]
- [Power key] + [Power key] (double press)
- [Vol+] + [Vol-]
- [Touch screen] + [Vol-]

OR just
- [Power key]
- [Vol+]

and etc.
> [!NOTE]
> The [Touch screen] option triggers the module when you move your finger across the screen,\
> this is avaliable only in the button combination

### Magisk action button
The action button of this module **enables** all Magisk modules\
Also, it can be executed using a command like this:
```shell
sh /data/adb/modules/abootloop/action.sh
```

### Custom recovery
Rename the module zip file to `disableall.zip`\
and flash it in your custom recovery to disable all Magisk modules\
This will automatically mount `modules.img`
> [!IMPORTANT]
> Not all recoveries can mount `modules.img`
