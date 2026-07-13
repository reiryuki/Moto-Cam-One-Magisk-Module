# Moto Cam One Magisk Module

## DISCLAIMER
- Moto apps are owned by Motorola™.
- The MIT license specified here is for the Magisk Module only, not for Moto apps.

## Descriptions
Stock camera HAL 1 app from Motorola ported and integrated as a Magisk Module for all supported and rooted devices with Magisk

## Sources
- https://play.google.com/store/apps/details?id=com.motorola.cameraone
- libmagiskpolicy.so: Magisk (stable) 30.7 (30700)

## Changelog

v1.18
- Update libmagiskpolicy.so from Magisk (stable) 30.7 (30700)
- Fix selinux denials
- Resets module folders/files permissions at post-fs-data
- Move _uninstall.log to /data/adb/logs/

v1.17
- Add Action button to clear app caches
- Fix architecture detection in some weird ROMs
- Fix bug in uninstall.sh

v1.16
- Fix a crash while using Google Lens feature
- Fix conflict with modules_update while installing via recovery if Magisk installed
- Fix MagiskHide & SUList

v1.15
- Remove ro.opengles.version detection to fix installation via Recovery if Magisk installed
- Redirect /sdcard to /data/media/"$UID"
- Fix MagiskHide & SUList

v1.14
- Specify UID at script
- Allow installation via Recovery if Magisk installed
- Add optional debug.log=1 for more detailed install log
- Fix permissions in Motorola devices

v1.13
- Using framework dex version 035 fix for Android Oreo and bellow
- KernelSU support
- Magisk v26.1 support
- Save install log at /sdcard/..._recovery.log while installing via Recovery
- Save uninstall log in /data/adb/modules/..._uninstall.log
- Fix optional permissive mode
- Set blacklist/whitelist

v1.12
- Fix a fatal exception
- Fix sepolicy denials

v1.11
- Mov dependency files to Moto Core Magisk Module
- This version requires Moto Core Magisk Module in non-Motorola ROM
- Fix permissions
- Creates /sdcard/optionals.prop file if doesn't exist
- Using sys.boot_completed=1 detection

v1.10
- package_cache deletion
- Fix sepolicy denials
- Script enhancements
- Move dalvik cache cleaning to cleaner.sh
- Using /sdcard/optionals.prop instead of terminal commands for any optional installation

v1.9
- Enable debug log
- Fix uninstall.sh bug

## Screenshots
https://t.me/androidryukimods/22

## Requirements
- Android 6 (SDK 23) and up
- Magisk or Kitsune Mask or KernelSU or Apatch installed
- Moto Core Magisk Module installed https://github.com/reiryuki/Moto-Core-Magisk-Module

## Installation Guide & Download Link
- If you are using KernelSU, you need to disable Unmount Modules by Default in KernelSU app settings and install https://github.com/KernelSU-Modules-Repo/meta-overlayfs or https://github.com/KernelSU-Modules-Repo/magic_mount_rs or https://github.com/KernelSU-Modules-Repo/hybrid_mount or https://github.com/maxsteeel/nomount first depending on ROM compatibility
- Install Moto Core Magisk Module first: https://github.com/reiryuki/Moto-Core-Magisk-Module
- Install this module via Magisk app or KernelSU app only
- Reboot
- If you are using KernelSU, you need to allow superuser list manually all package name listed in package.txt (and your home launcher app also) (enable show system apps) and reboot afterwards
- If you are using SUList, you need to allow list manually your home launcher app (enable show system apps) and reboot afterwards

## Known Issues
- Back camera slow motion doesn't work
- External memory card storage doesn't work
 
## Optionals
- https://t.me/ryukinotes/82
- Global: https://t.me/ryukinotes/35

## Troubleshootings
- https://t.me/ryukinotes/82
- Global: https://t.me/ryukinotes/34

## Support & Bug Report
- https://t.me/ryukinotes/54
- If you don't do above, issues will be closed immediately

## Credits and Contributors
- https://t.me/androidryukimodsdiscussions
- https://t.me/androidappsportdevelopment

## Sponsors
https://t.me/ryukinotes/25


