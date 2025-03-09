# Anti bootloop

[![Github releases](https://img.shields.io/github/downloads/Magisk-Modules-Alt-Repo/abootloop/total?logo=GitHub)](https://github.com/Magisk-Modules-Alt-Repo/abootloop/releases)
[![GitHub stargazers](https://img.shields.io/github/stars/Magisk-Modules-Alt-Repo/abootloop?style=flat&logo=Github&&color=e3b341)](https://github.com/Magisk-Modules-Alt-Repo/abootloop/stargazers)
[![License](https://img.shields.io/github/license/Magisk-Modules-Alt-Repo/abootloop)](https://github.com/Magisk-Modules-Alt-Repo/abootloop/blob/main/LICENSE)

Bootloop protection  
This module works in both `late_start` and `post-fs-data` modes  
so it can fix a bootloop at the early boot stage

## Usage

Customize your key combination during installation  
and click it while the system is booting to disable all Magisk modules

### Action button

The action button of this module **enables** all Magisk modules  
Also, it can be executed using a command like this:

```shell
sh /data/adb/modules/abootloop/action.sh
```
