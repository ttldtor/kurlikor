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

set(CMAKE_CXX_STANDARD 20)


if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(CMAKE_MACOSX_RPATH ON)
    set(CMAKE_SKIP_BUILD_RPATH ON)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH OFF)
    set(CMAKE_BUILD_RPATH_USE_ORIGIN ON)
    set(CMAKE_INSTALL_RPATH "@loader_path/../${CMAKE_INSTALL_LIBDIR};@loader_path;@executable_path;@executable_path/../Frameworks")
elseif (UNIX)
    set(CMAKE_SKIP_BUILD_RPATH ON)
    set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH OFF)
    set(CMAKE_BUILD_RPATH_USE_ORIGIN ON)
    set(CMAKE_INSTALL_RPATH "$ORIGIN/../${CMAKE_INSTALL_LIBDIR}:$ORIGIN/../lib64:$ORIGIN/../lib:$ORIGIN")
endif ()


add_library(${PROJECT_NAME} src/kurlikor.cpp)
add_library(kurlikor::kurlikor ALIAS ${PROJECT_NAME})

target_link_libraries(${PROJECT_NAME} PRIVATE Boost::beast Boost::asio Boost::url)
target_include_directories(${PROJECT_NAME} PUBLIC include)

if (KURLIKOR_INSTALL)
    install(TARGETS ${PROJECT_NAME})
    install(DIRECTORY "include" DESTINATION "." PATTERN "build" EXCLUDE)
endif ()
