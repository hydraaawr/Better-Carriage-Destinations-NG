cmake_minimum_required(VERSION 3.21)

project(
    BetterCarriageDestinations
    VERSION 1.0.10
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# unit tests of the vendored library are out of scope for the plugin build
set(BUILD_TESTS OFF CACHE BOOL "" FORCE)

add_subdirectory(lib/commonlibsse-ng)

include(lib/commonlibsse-ng/cmake/CommonLibSSE.cmake)

add_commonlibsse_plugin(
    BetterCarriageDestinations
    NAME "BetterCarriageDestinationsNG"
    AUTHOR "Shazdeh"
    VERSION 1.0.10
    SOURCES
        src/plugin.cpp
)

target_precompile_headers(BetterCarriageDestinations PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/include/PCH.h"
)

target_include_directories(BetterCarriageDestinations PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

set_target_properties(BetterCarriageDestinations PROPERTIES
    PREFIX ""
)
