# Returns all directories with headers
macro(header_directories return_list)
  file(GLOB_RECURSE new_list *.h)
  foreach(file_path ${new_list})
    get_filename_component(dir_path ${file_path} PATH)
    set(dir_list ${dir_list} ${dir_path})
  endforeach()
  list(REMOVE_DUPLICATES dir_list)
  set(${return_list} ${dir_list})
endmacro()


# Gets source files
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS *.cpp)
file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS *.h)
header_directories(DIRECTORIES)


# Gets libraries
include(${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

find_package(Threads)

# Creates main library
add_library(main_lib STATIC ${SOURCES} ${HEADERS})
target_include_directories(main_lib PUBLIC ${DIRECTORIES})

# Links libraries
target_link_libraries(main_lib Threads::Threads)
target_link_libraries(main_lib ${CONAN_LIBS})
