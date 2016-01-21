message(STATUS "Using Linux-arm toolchain file")

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR "armv7l")
set(CMAKE_LIBRARY_ARCHITECTURE "arm-linux-gnueabihf") # for Glibc/CMakeLists.txt
set(CMAKE_EXECUTABLE_FORMAT "ELF")

# TODO LLVM if(False AND CMAKE_CROSSCOMPILING) in llvm/tools/llvm-config/CMakeLists.txt

include(CMakeForceCompiler)

# 1) Run `brew install dpkg libelf`
# 2) Run `./utils/make_sysroot.py --distro ubuntu --version trusty --arch armhf --install <sysroot path>`
# 3) Download https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q3-update/+download/gcc-arm-none-eabi-4_9-2015q3-20150921-mac.tar.bz2
# 4) Untar gcc, and in gcc-arm-none-eabi-4_9-2015q3/bin/, strip the
#    "arm-none-eabi-" from all the tool names
#    Also replace ld with gold, I got my gold from the android ndk,
#    http://developer.android.com/ndk/downloads/index.html inside the archive
#    it's at toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/arm-linux-androideabi/bin/ld
# 5) Cherry-pick this onto your llvm tree: https://github.com/froody/swift-llvm/commit/3925ab7e5af2c48d3acd0d2d49505f923d013055
# 6) Run `./utils/build-script -R -- --reconfigure --build-swift-stdlib=0 --build-swift-sdk-overlay=0 --skip-build-benchmarks=1`
#    to build llvm, clang and swiftc
# 7) Run 
#    `./utils/build-script -R -- --reconfigure --build-swift-tools=0 \
#    --native-llvm-tools-path="../build/Ninja-ReleaseAssert/llvm-macosx-x86_64/bin" \
#    --native-clang-tools-path="foo" \
#    --native-swift-tools-path="../build/Ninja-ReleaseAssert/swift-macosx-x86_64/bin" \
#    --cross-compile-tools-deployment-targets=linux-armv7 \
#    --skip-build-cmark=1 --skip-build-llvm=1 --skip-build-osx=1 \
#    --cross-compile-sysroot=<sysroot path from (2)>
#    --cross-compile-toolchain-bin=<bin directory from (4)>`
#

# To iterate development, you just need to re-run step (7), if you make changes
# to swiftc you'll need to run step (6) then step (7), but dependencies might
# not be right

SET(CMAKE_AR ${CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN}/ar CACHE FILEPATH "Archiver") # https://cmake.org/Bug/view.php?id=13038

set(CMAKE_CXX_COMPILER_VERSION 3.6)

link_directories(${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf/
                 ${CMAKE_SYSROOT}/usr/lib/gcc/arm-linux-gnueabihf/4.8/)
include_directories(SYSTEM
                ${CMAKE_SYSROOT}/usr/include/c++/4.8/
                ${CMAKE_SYSROOT}/usr/include/arm-linux-gnueabihf/c++/4.8/)

# Used to find BSD and ICU among other things
set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})

set(CMAKE_C_COMPILER_TARGET arm-linux-gnueabihf)
set(CMAKE_CXX_COMPILER_TARGET arm-linux-gnueabihf)
CMAKE_FORCE_C_COMPILER("${CMAKE_C_COMPILER}" Clang)
CMAKE_FORCE_CXX_COMPILER("${CMAKE_CXX_COMPILER}" Clang)

