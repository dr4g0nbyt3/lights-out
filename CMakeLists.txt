cmake_minimum_required(VERSION 3.15)
project(LightsOut VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set output directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Find BakkesMod SDK
# You need to set BAKKESMOD_SDK_DIR to the path where you cloned the SDK
if(NOT DEFINED BAKKESMOD_SDK_DIR)
    set(BAKKESMOD_SDK_DIR "$ENV{BAKKESMOD_SDK_DIR}")
endif()

if(NOT EXISTS ${BAKKESMOD_SDK_DIR})
    message(FATAL_ERROR "BakkesMod SDK not found. Please set BAKKESMOD_SDK_DIR to the SDK path.")
endif()

# Include BakkesMod SDK headers
include_directories(${BAKKESMOD_SDK_DIR}/include)

# Link directories for BakkesMod SDK
link_directories(${BAKKESMOD_SDK_DIR}/lib)

# Create the plugin DLL
add_library(LightsOut SHARED
    LightsOutPlugin.cpp
    LightsOutPlugin.h
)

# Link against the BakkesMod Plugin SDK library
target_link_libraries(LightsOut PRIVATE
    pluginsdk
)

# Set compile options
if(MSVC)
    target_compile_options(LightsOut PRIVATE /W4)
endif()

# Install target
install(TARGETS LightsOut
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION bin
)

message(STATUS "LightsOut plugin configured successfully!")
message(STATUS "BakkesMod SDK: ${BAKKESMOD_SDK_DIR}")
