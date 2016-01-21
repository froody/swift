message(STATUS "To the android... to the WALL!")

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR "arm")
set(CMAKE_SYSTEM_VERSION 21)
set(CMAKE_EXECUTABLE_FORMAT "ELF")

# TODO LLVM if(False AND CMAKE_CROSSCOMPILING) in llvm/tools/llvm-config/CMakeLists.txt

include(CMakeForceCompiler)

set(CMAKE_SYSROOT /Users/tbirch/src/android-ndk-r10e/platforms/android-21/arch-arm)

#CMAKE_FORCE_C_COMPILER(arm-linux-androideabi-gcc GNU)
#CMAKE_FORCE_CXX_COMPILER(arm-linux-androideabi-g++ GNU)
#set(CMAKE_C_COMPILER /Users/tbirch/src/android-ndk-r10e/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin/arm-linux-androideabi-gcc)
#set(CMAKE_CXX_COMPILER /Users/tbirch/src/android-ndk-r10e/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin/arm-linux-androideabi-g++)
#set(CMAKE_CXX_COMPILER_VERSION 4.9)
SET(ANDROID_NDK_ROOT /Users/tbirch/src/android-ndk-r10e)
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

set(CMAKE_C_COMPILER_TARGET armv7-none-linux-androideabi)
set(CMAKE_CXX_COMPILER_TARGET armv7-none-linux-androideabi)
#set(CMAKE_C_FLAGS -B /tacotruck)
#set(CMAKE_CXX_FLAGS ${CMAKE_C_FLAGS} -isystem /Users/tbirch/src/android-ndk-r10e/sources/cxx-stl/llvm-libc++/libcxx/include)
CMAKE_FORCE_C_COMPILER("${CMAKE_C_COMPILER}" Clang)
CMAKE_FORCE_CXX_COMPILER("${CMAKE_CXX_COMPILER}" Clang)

set(_CMAKE_TOOLCHAIN_LOCATION /Users/tbirch/src/android-ndk-r10e/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin/)
set(CMAKE_FIND_ROOT_PATH /Users/tbirch/src/android-ndk-r10e/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/)
##SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)
#SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
#SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
