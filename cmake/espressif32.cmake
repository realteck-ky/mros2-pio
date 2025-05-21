set(SRCS
    ${MROS2_CORE_PATH}/embeddedRTPS/src/communication/UdpDriver.cpp
    ${MROS2_CORE_PATH}/embeddedRTPS/src/messages/MessageTypes.cpp
    ${MROS2_CORE_PATH}/embeddedRTPS/src/messages/MessageReceiver.cpp
    ${MROS2_CORE_PATH}/embeddedRTPS/src/discovery/TopicData.cpp
    ${MROS2_CORE_PATH}/embeddedRTPS/src/discovery/ParticipantProxyData.cpp
    ${MROS2_CORE_PATH}/embeddedRTPS/src/discovery/SEDPAgent.cpp
    ${MROS2_CORE_PATH}/embeddedRTPS/src/discovery/SPDPAgent.cpp
    ${MROS2_CORE_PATH}/embeddedRTPS/src/storages/PBufWrapper.cpp
    ${MROS2_CORE_PATH}/embeddedRTPS/src/ThreadPool.cpp
    ${MROS2_CORE_PATH}/embeddedRTPS/src/entities/Participant.cpp
    ${MROS2_CORE_PATH}/embeddedRTPS/src/entities/Domain.cpp
    ${MROS2_CORE_PATH}/embeddedRTPS/src/entities/StatelessReader.cpp
    ${MROS2_CORE_PATH}/embeddedRTPS/thirdparty/Micro-CDR/src/c/common.c
    ${MROS2_CORE_PATH}/embeddedRTPS/thirdparty/Micro-CDR/src/c/types/basic.c
    ${MROS2_CORE_PATH}/embeddedRTPS/thirdparty/Micro-CDR/src/c/types/string.c
    ${MROS2_CORE_PATH}/embeddedRTPS/thirdparty/Micro-CDR/src/c/types/sequence.c
    ${MROS2_CORE_PATH}/embeddedRTPS/thirdparty/Micro-CDR/src/c/types/array.c
    ${MROS2_CORE_PATH}/embeddedRTPS/thirdparty/lwip/default_netif.c
    ${MROS2_CORE_PATH}/src/mros2.cpp
    ${MROS2_PLATFORM_PATH}/cmsis/lwip.c
    ${MROS2_PLATFORM_PATH}/cmsis/cmsis-esp.c
    ${MROS2_PLATFORM_PATH}/wifi/wifi.c
    ${MROS2_PLATFORM_PATH}/mros2-platform.cpp
    )

set(INCS
    ${MROS2_CORE_PATH}/include
    ${MROS2_CORE_PATH}/include/mros2
    ${MROS2_CORE_PATH}/mros2_msgs
    ${MROS2_CORE_PATH}/embeddedRTPS/include
    ${MROS2_CORE_PATH}/embeddedRTPS/thirdparty/lwip
    ${MROS2_CORE_PATH}/embeddedRTPS/thirdparty/Micro-CDR/include
    ${MROS2_PLATFORM_PATH}/cmsis/include
    ${MROS2_PLATFORM_PATH}
    ${MROS2_PLATFORM_PATH}/wifi
    )

if(PIOLIB EQUAL 1)
    file(WRITE "${CMAKE_BINARY_DIR}/mros2_source_list.txt")
    foreach(SRC_PATH IN LISTS SRCS)
        file(APPEND "${CMAKE_BINARY_DIR}/mros2_source_list.txt" "${SRC_PATH}\n")
    endforeach()
    file(WRITE "${CMAKE_BINARY_DIR}/mros2_include_list.txt")
    foreach(INC_PATH IN LISTS INCS)
        file(APPEND "${CMAKE_BINARY_DIR}/mros2_include_list.txt" "${INC_PATH}\n")
    endforeach()
endif()

if(ESP_PLATFORM EQUAL 1)
    if(NOT CMAKE_BUILD_EARLY_EXPANSION)
        add_compile_options(-w)
    endif()

    idf_component_register(
        SRCS ${SRCS}
        INCLUDE_DIRS ${INCS}
        REQUIRES nvs_flash esp_wifi)

    # Generate plaform/templates.hpp from mros2 application code
    ## You can add dir(s) in `--indir` if you have several dirs
    ## that contain application code files
    add_custom_command(
            OUTPUT templates.hpp
            COMMAND python3 ${COMPONENT_PATH}/mros2/mros2_header_generator/templates_generator.py --outdir ${COMPONENT_PATH}/platform --indir ${CMAKE_SOURCE_DIR}/main)
    add_custom_target(Template SOURCES templates.hpp)
    add_dependencies(${COMPONENT_LIB} Template)

    # Disable CONFIG_LWIP_IPV6 in `sdkconfig` in build process
    ## This realizes the same behavior by `idf.py menuconfig`.
    ## However, you need to do `idf.py build` twice to refrect
    ## all the settings properly.
    message(STATUS "PROJECT=${PROJECT_NAME}")
    add_custom_command(
            OUTPUT sdkconfig
            COMMAND grep -q CONFIG_LWIP_IPV6=y ${CMAKE_SOURCE_DIR}/sdkconfig || exit 0 && sed -i 's/CONFIG_LWIP_IPV6=y/CONFIG_LWIP_IPV6=n/g' ${CMAKE_SOURCE_DIR}/sdkconfig)
    add_custom_target(Sdkconfig SOURCES sdkconfig)
    add_dependencies(${COMPONENT_LIB} Sdkconfig)
endif()
