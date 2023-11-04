MESSAGE(STATUS "KURLIKOR_TARGET_PLATFORM: ${KURLIKOR_TARGET_PLATFORM}")
MESSAGE(STATUS "KURLIKOR_TARGET_OS: ${KURLIKOR_TARGET_OS}")
MESSAGE(STATUS "KURLIKOR_TARGET_CPU: ${KURLIKOR_TARGET_CPU}")

if ((KURLIKOR_TARGET_PLATFORM STREQUAL "unknown-unknown"))
    if ((DEFINED $ENV{KURLIKOR_CUSTOM_OS}) AND (KURLIKOR_TARGET_OS STREQUAL "unknown"))
        if ($ENV{KURLIKOR_CUSTOM_OS} MATCHES "win")
            set(KURLIKOR_TARGET_OS "windows")
        elseif (($ENV{KURLIKOR_CUSTOM_OS} MATCHES "mac") OR ($ENV{KURLIKOR_CUSTOM_OS} MATCHES "osx"))
            set(KURLIKOR_TARGET_OS "osx")
        elseif (($ENV{KURLIKOR_CUSTOM_OS} MATCHES "linux"))
            set(KURLIKOR_TARGET_OS "linux")
        else ()
            set(KURLIKOR_TARGET_OS $ENV{KURLIKOR_CUSTOM_OS})
        endif ()
    endif ()

    if ((DEFINED $ENV{KURLIKOR_CUSTOM_CPU}) AND (${KURLIKOR_TARGET_CPU} STREQUAL "unknown"))
        if (($ENV{KURLIKOR_CUSTOM_CPU} MATCHES "amd64") OR ($ENV{KURLIKOR_CUSTOM_CPU} MATCHES "x86_64"))
            set(KURLIKOR_TARGET_CPU "x86_64")
        elseif (($ENV{KURLIKOR_CUSTOM_CPU} MATCHES "arm64") OR ($ENV{KURLIKOR_CUSTOM_CPU} MATCHES "aarch64"))
            set(KURLIKOR_TARGET_CPU "aarch64")
        else ()
            set(KURLIKOR_TARGET_CPU $ENV{KURLIKOR_CUSTOM_CPU})
        endif ()
    endif ()
else ()
        string(REPLACE "-" ";" KURLIKOR_TARGET_CPU_AND_OS ${KURLIKOR_TARGET_PLATFORM})
        list(LENGTH KURLIKOR_TARGET_CPU_AND_OS KURLIKOR_TARGET_CPU_AND_OS_LENGTH)

        if (KURLIKOR_TARGET_CPU_AND_OS_LENGTH EQUAL 1)
            list(GET KURLIKOR_TARGET_CPU_AND_OS 0 KURLIKOR_TARGET_CPU_OR_OS)
            if ((KURLIKOR_TARGET_CPU_OR_OS MATCHES "64") OR (KURLIKOR_TARGET_CPU_OR_OS MATCHES "x86") OR (KURLIKOR_TARGET_CPU_OR_OS MATCHES "arm"))
                if (KURLIKOR_TARGET_CPU STREQUAL "unknown")
                    set(KURLIKOR_TARGET_CPU ${KURLIKOR_TARGET_CPU_OR_OS})
                endif ()

            else ()
                if (KURLIKOR_TARGET_OS STREQUAL "unknown")
                    set(KURLIKOR_TARGET_OS ${KURLIKOR_TARGET_CPU_OR_OS})
                endif ()

            endif ()
        else ()
            if (KURLIKOR_TARGET_CPU STREQUAL "unknown")
                list(GET KURLIKOR_TARGET_CPU_AND_OS 0 KURLIKOR_TARGET_CPU)
            endif ()

            if (KURLIKOR_TARGET_OS STREQUAL "unknown")
                list(GET KURLIKOR_TARGET_CPU_AND_OS 1 KURLIKOR_TARGET_OS)
            endif ()

        endif ()
endif ()

set(KURLIKOR_CURRENT_OS "unknown")

if (WIN32)
    set(KURLIKOR_CURRENT_OS "windows")
elseif (APPLE)
    set(KURLIKOR_CURRENT_OS "osx")
elseif (UNIX)
    set(KURLIKOR_CURRENT_OS "linux")
endif ()

if (KURLIKOR_TARGET_OS STREQUAL "unknown")
    set(KURLIKOR_TARGET_OS ${KURLIKOR_CURRENT_OS})
endif ()

set(KURLIKOR_CURRENT_CPU "unknown")

if ((CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "arm64") OR (CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "aarch64") OR (CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "ARM64") OR (CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "AARCH64"))
    set(KURLIKOR_CURRENT_CPU "aarch64")
elseif ((CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "x86_64") OR (CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "amd64") OR (CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "AMD64"))
    set(KURLIKOR_CURRENT_CPU "x86_64")
else ()
    set(KURLIKOR_CURRENT_CPU ${CMAKE_HOST_SYSTEM_PROCESSOR})
endif ()

if (KURLIKOR_TARGET_CPU STREQUAL "unknown")
    set(KURLIKOR_TARGET_CPU ${KURLIKOR_CURRENT_CPU})
endif ()

#normalization

if (KURLIKOR_TARGET_OS STREQUAL "windows" OR KURLIKOR_TARGET_OS STREQUAL "linux")
    if (KURLIKOR_TARGET_CPU STREQUAL "amd64")
        set(KURLIKOR_TARGET_CPU "x86_64")
    endif ()
endif ()

if (${KURLIKOR_TARGET_PLATFORM} MATCHES "unknown")
    set(KURLIKOR_TARGET_PLATFORM "${KURLIKOR_TARGET_CPU}-${KURLIKOR_TARGET_OS}")
endif ()

MESSAGE(STATUS "KURLIKOR_TARGET_PLATFORM: ${KURLIKOR_TARGET_PLATFORM}")
MESSAGE(STATUS "KURLIKOR_TARGET_OS: ${KURLIKOR_TARGET_OS}")
MESSAGE(STATUS "KURLIKOR_TARGET_CPU: ${KURLIKOR_TARGET_CPU}")