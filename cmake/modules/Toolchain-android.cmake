message(STATUS "Using android toolchain file")

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR "armv7")
set(CMAKE_SYSTEM_VERSION 21)
set(CMAKE_EXECUTABLE_FORMAT "ELF")

# TODO LLVM if(False AND CMAKE_CROSSCOMPILING) in llvm/tools/llvm-config/CMakeLists.txt

include(CMakeForceCompiler)

SET(ANDROID_NDK_ROOT "$ENV{ANDROID_NDK_HOME}")

if("${ANDROID_NDK_ROOT}" STREQUAL "")
  message(FATAL_ERROR "environmental variable ANDROID_NDK_HOME not set")
endif()

SET(CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN ${ANDROID_NDK_ROOT}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/arm-linux-androideabi/bin)
SET(CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN ${CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN})
SET(CMAKE_AR ${CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN}/ar CACHE FILEPATH "Archiver") # https://cmake.org/Bug/view.php?id=13038
SET(CMAKE_RANLIB ${CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN}/ranlib)
#message("cmake ar ${CMAKE_AR}, ${CMAKE_RANLIB}, ${CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN},")


set(CMAKE_C_COMPILER ${ANDROID_NDK_ROOT}/toolchains/llvm-3.6/prebuilt/darwin-x86_64/bin/clang)
set(CMAKE_CXX_COMPILER ${ANDROID_NDK_ROOT}/toolchains/llvm-3.6/prebuilt/darwin-x86_64/bin/clang++)
set(CMAKE_CXX_COMPILER_VERSION 3.6)
set(CMAKE_EXE_LINKER_FLAGS -lc++_shared)
link_directories(${ANDROID_NDK_ROOT}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9/
                 ${ANDROID_NDK_ROOT}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/arm-linux-androideabi/lib/
                 ${ANDROID_NDK_ROOT}/sources/cxx-stl/llvm-libc++/libs/armeabi)
include_directories(SYSTEM
                    ${ANDROID_NDK_ROOT}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9/include/
                    ${ANDROID_NDK_ROOT}/sources/cxx-stl/llvm-libc++/libcxx/include
                    ${ANDROID_NDK_ROOT}/sources/android/support/include)

# Used to find BSD and ICU among other things
set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})

set(CMAKE_C_COMPILER_TARGET armv7-none-linux-androideabi)
set(CMAKE_CXX_COMPILER_TARGET armv7-none-linux-androideabi)
#set(CMAKE_C_FLAGS -B /tacotruck)
CMAKE_FORCE_C_COMPILER("${CMAKE_C_COMPILER}" Clang)
CMAKE_FORCE_CXX_COMPILER("${CMAKE_CXX_COMPILER}" Clang)

##SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)
#SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
#SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
