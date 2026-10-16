#!/bin/bash

export ARCH=arm64
export PLATFORM_VERSION=13
export ANDROID_MAJOR_VERSION=t
export CONFIG_SECTION_MISMATCH_WARN_ONLY=y

export PATH=$HOME/.local/share/mamba/envs/py2/bin:$PATH

MAKE_ARGS=(
  ARCH=arm64
  -j7
  CC=./buildtools/samsung-toolchain/clang/host/linux-x86/clang-r349610-jopp/bin/clang
  CROSS_COMPILE=./buildtools/samsung-toolchain/gcc-cfp/gcc-cfp-jopp-only/aarch64-linux-android-4.9/bin/aarch64-linux-android-
  CLANG_TRIPLE=./buildtools/linaro-gcc-4.9/bin/aarch64-linux-gnu-
)

if [ "$1" = "clean" ]; then
  echo 'cleaning old build'
  make "${MAKE_ARGS[@]}" mrproper
  rm -f .config
fi

echo 'getting build tools'
./setup_repos.sh

if [ ! -f .config ]; then
  echo 'making defconfig'
  make "${MAKE_ARGS[@]}" exynos9810-r7_defconfig
fi

echo 'building kernel'
make "${MAKE_ARGS[@]}"
