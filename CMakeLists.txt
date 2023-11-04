# Copyright (c) 2023 ttldtor.
# SPDX-License-Identifier: BSL-1.0

cmake_minimum_required(VERSION 3.20)

project(kurlikor)

if (POLICY CMP0092)
    cmake_policy(SET CMP0092 NEW)
endif ()

if (POLICY CMP0135)
    cmake_policy(SET CMP0135 NEW)
endif ()

set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)

set(KURLIKOR_VERSION "v0.1.0-alpha" CACHE STRING "The Kurlikor package version")

set(CMAKE_CXX_STANDARD 20)

option(KURLIKOR_INSTALL "Prepare install" ON)

include(FetchContent)

set(KURLIKOR_GRAAL_TARGET_PLATFORM "unknown-unknown" CACHE STRING "")
set(KURLIKOR_TARGET_PLATFORM "unknown-unknown" CACHE STRING "")
set(KURLIKOR_TARGET_OS "unknown" CACHE STRING "")
set(KURLIKOR_GRAAL_TARGET_OS "unknown" CACHE STRING "")
set(KURLIKOR_TARGET_CPU "unknown" CACHE STRING "")
set(KURLIKOR_GRAAL_TARGET_CPU "unknown" CACHE STRING "")

include(ParseAndDetectPlatforms.cmake)


add_subdirectory(lib)
add_subdirectory(kurlikor-cli)


if (KURLIKOR_INSTALL)
    include(GNUInstallDirs)
    set(CPACK_OUTPUT_CONFIG_FILE "${CMAKE_BINARY_DIR}/${PROJECT_NAME}PackConfig.cmake")
    set(CPACK_SOURCE_GENERATOR ZIP)
    set(CPACK_PACKAGE_VENDOR "ttldtor")
    set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
    set(CPACK_PACKAGE_VERSION "${KURLIKOR_VERSION}")
    set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${KURLIKOR_VERSION}-${KURLIKOR_TARGET_PLATFORM}${KURLIKOR_PACKAGE_SUFFIX}")
    include(CPack)

    install(FILES "LICENSE" "README.md" DESTINATION ".")
endif ()