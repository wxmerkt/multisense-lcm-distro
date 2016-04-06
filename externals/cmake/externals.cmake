set(bot_core_lcmtypes_url https://github.com/iamwolf/bot_core_lcmtypes.git)
set(bot_core_lcmtypes_revision c29cd6076d13ca2a3ecc23ffcbe28a0a1ab46314)
set(bot_core_lcmtypes_depends ${lcm_proj})

set(libbot_url https://github.com/openhumanoids/libbot.git)
set(libbot_revision 49d34ae743ab7273640a33cf5509826d6b85e295)
set(libbot_depends bot_core_lcmtypes ${lcm_proj})

set(opencv_proj opencv)
set(opencv_url https://github.com/Itseez/opencv.git)
set(opencv_revision 2.4.12.3)
set(opencv_depends Eigen_pod)
set(opencv_external_args
  CMAKE_CACHE_ARGS
    ${default_cmake_args}
    ${python_args}
    -DWITH_CUDA:BOOL=OFF
  )

set(Eigen_pod_url https://github.com/RobotLocomotion/eigen-pod.git)
set(Eigen_pod_revision ceba39500b89a77a8649b3e8b421b10a3d74d42b)
set(Eigen_pod_depends)

set(common_utils_url https://github.com/openhumanoids/common_utils.git)
set(common_utils_revision bf0c9223e02a193a3cfef4034ef82a94219f116a)
set(common_utils_depends Eigen_pod libbot)

#set(fovis_url https://github.com/fovis/fovis.git)
#set(fovis_revision ee2fe6593ed9e7e5ce2b2f6f1c64b627da119090)
#set(fovis_depends libbot)

set(externals
  Eigen_pod
  bot_core_lcmtypes
  libbot
  opencv
  common_utils
  #fovis
)


macro(add_external proj)
  # depending on which variables are defined, the external project
  # might be mercurial, svn, git, or an archive download.
  if(DEFINED ${proj}_hg_tag)
    set(download_args
      HG_REPOSITORY ${${proj}_url}
      HG_TAG ${${proj}_hg_tag})
  elseif(DEFINED ${proj}_svn_revision)
    set(download_args
    SVN_REPOSITORY ${${proj}_url}
    SVN_REVISION -r ${${proj}_revision})
  elseif(DEFINED ${proj}_download_hash)
    set(download_args
    URL ${${proj}_url}
    URL_MD5 ${${proj}_download_hash})
  else()
    set(download_args
      GIT_REPOSITORY ${${proj}_url}
      GIT_TAG ${${proj}_revision})
  endif()

  # if this variable is not defined then this external will be treated as
  # a standard pod so we'll define the required configure and build commands
  if(NOT DEFINED ${proj}_external_args)
    set(pod_build_args
      CONFIGURE_COMMAND ${empty_command}
      INSTALL_COMMAND ${empty_command}
      BUILD_COMMAND $(MAKE) BUILD_PREFIX=${CMAKE_INSTALL_PREFIX} BUILD_TYPE=${CMAKE_BUILD_TYPE} ${${proj}_environment_args}
      BUILD_IN_SOURCE 1
    )
    set(${proj}_external_args ${pod_build_args})
    set(${proj}_is_pod TRUE)
  endif()

  # this supports non-standard download locations
  set(source_dir_arg)
  list(FIND ${proj}_external_args SOURCE_DIR res)
  if (res EQUAL -1)
    set(source_dir_arg SOURCE_DIR ${source_prefix}/${proj})
  endif()

  # workaround a cmake issue, we need to support empty strings as list elements
  # so replace the string NONE with empty string here right before arg conversion
  # and then the variable will be quoted in the following call to ExternalProject_Add.
  string(REGEX REPLACE "NONE" "" ${proj}_external_args "${${proj}_external_args}")

  ExternalProject_Add(${proj}
    DEPENDS ${${proj}_depends}
    ${download_args}
    ${source_dir_arg}
    "${${proj}_external_args}"
    )
endmacro()


foreach(external ${externals})
  add_external(${external})
endforeach()
