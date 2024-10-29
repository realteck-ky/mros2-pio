# mROS 2 for PlatformIO

This is [mROS 2](https://github.com/mROS-base/mros2) library for PlatformIO.

[mROS 2](https://github.com/mROS-base/mros2) is yet another runtime environment onto embedded devices.

## Supported boards

TODO:

> [!CAUTION]  
> The official page describes that supported platforms are TOPPERS, Mbed OS, ESP-IDF (FreeRTOS), and POSIX OS.  
> However, this library currently only supports ESP-IDF and ESP32 because it is very experimental.  
> Most programs of mROS 2 for ESP-IDF are based on the following repositories: [mros2-esp32](https://github.com/mROS-base/mros2-esp32).  
> This version is only checked for building, so it is not confirmed to run.  

## Quick start

Create a PlatformIO project, and add this repository URL to the `lib_deps` like following.

```ini
[env:m5stack-core-esp32]
platform = espressif32
board = m5stack-core-esp32
framework = espidf
lib_deps = https://github.com/realteck-ky/mros2-pio
```

The `examples` folder has useful mROS 2 application programs.
Copy it as main code in the `src` directory and build the project.
