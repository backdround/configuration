cmake_minimum_required(VERSION 3.12.2)
project(app CXX)

# Project configuration
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Imports main_lib
add_subdirectory(src)

# Gets main conan libraries
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

# Creates binary
add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} main_lib)
target_link_libraries(${PROJECT_NAME} ${CONAN_LIBS})
