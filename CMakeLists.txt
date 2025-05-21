cmake_minimum_required(VERSION 3.16.0)

set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)

project(mros2-pio
  VERSION 1.0.0
  LANGUAGES CXX C
)

set_property(CACHE MROS2_PLATFORM PROPERTY STRINGS "native" "espressif32")
# set_property(CACHE MROS2_FRAMEWORK PROPERTY STRINGS "posix" "arduino" "zephyr" "freertos")

set(MROS2_CORE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/mros2")
set(MROS2_PLATFORM_PATH "${CMAKE_CURRENT_SOURCE_DIR}/platform/${MROS2_PLATFORM}")

if(${MROS2_PLATFORM} MATCHES "espressif32")
include(cmake/espressif32.cmake)
else()
  # Error
  # if(not(DEFINED LIBRARY_LAST))
endif()
