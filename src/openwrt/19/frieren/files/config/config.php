<?php
class DeviceConfig
{
    const GUESS_TYPE = 'OpenWrt';
    const MODULE_ROOT_FOLDER = '/usr/share/frieren/modules';
    const MODULE_SD_ROOT_FOLDER = '/sd/modules';
    const MODULE_USE_INTERNAL_STORAGE = true;
    const MODULE_USE_USB_STORAGE = true;
    const MODULE_HIDE_SYSTEM_MODULES = true;
    const MODULE_SERVER_URL = 'https://raw.githubusercontent.com/xchwarze/frieren-modules-release/master';
    const MODULE_JSON_PATH = '%s/json/modules.json';
    const MODULE_PACKAGE_PATH = '%s/modules/%s';
}
