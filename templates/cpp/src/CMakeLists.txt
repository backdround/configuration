macro(header_directories return_list)
  file(GLOB_RECURSE new_list *.h)
  foreach(file_path ${new_list})
    get_filename_component(dir_path ${file_path} PATH)
    set(dir_list ${dir_list} ${dir_path})
  endforeach()
  list(REMOVE_DUPLICATES dir_list)
  set(${return_list} ${dir_list})
endmacro()

# Get source files
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS *.cpp)
file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS *.h)
header_directories(DIRECTORIES)


# Create main library
add_library(main_lib STATIC ${SOURCES} ${HEADERS})
target_include_directories(main_lib PUBLIC ${DIRECTORIES})


# Create binary
add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} main_lib)
