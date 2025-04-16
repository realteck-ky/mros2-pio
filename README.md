# mros2-esp32

mROS 2 (`mros2` as casually codename) realizes a agent-less and lightweight runtime environment compatible with ROS 2 for embedded devices.
mROS 2 mainly offers pub/sub APIs compatible with [rclcpp](https://docs.ros.org/en/rolling/p/rclcpp/index.html) for embedded devices.

mROS 2 consists of communication library for pub/sub APIs, RTPS protocol, UDP/IP stack, and real-time kernel.
This repository provides the reference implementation of mROS 2 that can be operated on the [Espressif Systems ESP32](https://www.espressif.com/en/products/socs/esp32) boards.
Please also check [mros2 repository](https://github.com/mROS-base/mros2) for more details and another implementations.

## Supported environment

- Target device: ESP32 family
  - Boards
    - For now, these boards below are confirmed to run the example on them.
      - [ESP32-S3-DevKitC-1](https://docs.espressif.com/projects/esp-idf/en/latest/esp32s3/hw-reference/esp32s3/user-guide-devkitc-1.html)
    - These boards below are also confirmed by the development team, but not always supported in the latest version (due to our development resources,,,).
      - [M5Stack Basic](http://docs.m5stack.com/en/core/basic)
      - [M5Stack Core2](http://docs.m5stack.com/en/core/core2)
      - [M5Stack CoreS3](http://docs.m5stack.com/en/core/CoreS3)
    - These boards were confirmed to operate by our friendly users (any PRs are welcome to add this list based on your experience!!)
      - [Seeed Studio XIAO ESP32C3](https://www.seeedstudio.com/Seeed-XIAO-ESP32C3-p-5431.html) (see [#7](https://github.com/mROS-base/mros2-esp32/issues/7))
      - [ESP32-C6-DevKitC-1](https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32c6/esp32-c6-devkitc-1/user_guide.html) (see [#21](https://github.com/mROS-base/mros2-esp32/issues/21))
      - [Seeed Studio XIAO ESP32C6](https://www.seeedstudio.com/Seeed-Studio-XIAO-ESP32C6-p-5884.html) (see [#23](https://github.com/mROS-base/mros2-esp32/issues/23))
      - [Seeed Studio XIAO ESP32S3](https://www.seeedstudio.com/XIAO-ESP32S3-p-5627.html) (see [#24](https://github.com/mROS-base/mros2-esp32/issues/24))
  - SDK: [ESP-IDF](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/index.html)
  - Kernel: [ESP-IDF FreeRTOS](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/system/freertos_idf.html)
- Host environment
  - [ROS 2 Humble Hawksbill](https://docs.ros.org/en/humble/index.html) on Ubuntu 22.04 LTS
- Network setting
  - Make sure both the device and the host are connected to the same network.
  - IP address needs to be assigned to the device by DHCP. We have not confirmed the operation using static IP setting yet. So you may not un-comment the `#define STATIC_IP` line in `platform/wifi/wifi.h`.
  - Please prepare the Wi-Fi router that provides 2.4 GHz band.
    - Most of ESP32 only support 2.4 GHz.
    - Note that you need to set up a dedicated SSID at 2.4 GHz. If the SSID has a band steering setting (that shares 2.4 GHz and 5 GHz), the communication of ESP32 may be disconnected during the operation.
  - The firewall on the host (Ubuntu) needs to be disabled for ROS 2 (DDS) communication (e.g. `$ sudo ufw disable`).
  - If the host is connected to the Internet with other network adapters, communication with mros2 may not work properly. In that case, please turn off them.

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
