find_package(Qt5 COMPONENTS Test REQUIRED)

function(custom_add_test TEST_NAME TEST_SOURCES)
  add_executable(${TEST_NAME} ${TEST_SOURCES})

  target_link_libraries(${TEST_NAME} main_lib Qt5::Test)

  add_test(${TEST_NAME} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TEST_NAME})
endfunction()

custom_add_test(example_test example_test.cpp)
