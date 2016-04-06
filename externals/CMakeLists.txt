cmake_minimum_required(VERSION 2.8.5)
project(Externals)

# set a default build type if none was specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'Release' as none was specified.")
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
  # set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

include(ExternalProject)
set_property(DIRECTORY PROPERTY EP_PREFIX ${Externals_BINARY_DIR})

set(source_prefix ${Externals_SOURCE_DIR})

set(default_cmake_args
  -DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
)

set(empty_command NONE)
set(download_only_args
  CONFIGURE_COMMAND ${empty_command}
  BUILD_COMMAND ${empty_command}
  INSTALL_COMMAND ${empty_command}
)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wreturn-type -Wuninitialized -Wunused-variable")

# python
find_package(PythonLibs 2.7 REQUIRED)

set(python_args
  -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_DIR}
  -DPYTHON_INCLUDE_DIR2:PATH=${PYTHON_INCLUDE_DIR}
  -DPYTHON_LIBRARY:PATH=${PYTHON_LIBRARY}
  )

include(cmake/externals.cmake)
