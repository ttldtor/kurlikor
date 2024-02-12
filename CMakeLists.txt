# Copyright (c) 2024 ttldtor.
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

set(KURLIKOR_TARGET_PLATFORM "unknown-unknown" CACHE STRING "")
set(KURLIKOR_TARGET_OS "unknown" CACHE STRING "")
set(KURLIKOR_TARGET_CPU "unknown" CACHE STRING "")

include(ParseAndDetectPlatforms.cmake)

# Add boost lib sources
set(BOOST_INCLUDE_LIBRARIES asio beast url)
set(BOOST_ENABLE_CMAKE ON)

# Download and extract the boost library from GitHub
message(STATUS "Downloading and extracting boost library sources. This will take some time...")
include(FetchContent)
set(FETCHCONTENT_QUIET FALSE) # Needed to print downloading progress
FetchContent_Declare(
        Boost
        URL https://github.com/boostorg/boost/releases/download/boost-1.84.0/boost-1.84.0.7z # downloading a zip release speeds up the download
        USES_TERMINAL_DOWNLOAD TRUE
        GIT_PROGRESS TRUE
        DOWNLOAD_NO_EXTRACT FALSE
)
FetchContent_MakeAvailable(Boost)

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