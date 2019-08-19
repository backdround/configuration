cmake_minimum_required(VERSION 3.0)
project(app)

find_package(Threads)
set(CMAKE_CXX_STANDARD 17)


add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} ${CMAKE_THREAD_LIBS_INIT})
