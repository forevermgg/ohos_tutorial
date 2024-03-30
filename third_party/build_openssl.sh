#!/bin/bash

set -e
set -o pipefail

# 获取脚本所在目录的绝对路径
SCRIPT_DIR=$(dirname "$(realpath "$0")")
echo "Script directory: $SCRIPT_DIR"

# 设置OHOS_NATIVE_HOME和路径
OHOS_NATIVE_HOME=/Users/forevermeng/CLionProjects/ohos_tutorial/mac-sdk-full/sdk/packages/ohos-sdk/darwin/native
export OHOS_NATIVE_HOME
export PATH="$OHOS_NATIVE_HOME/llvm/bin:$PATH"

# 配置不同架构环境变量
configure_architecture() {
    local arch=$(tr [A-Z] [a-z] <<< "$1")
    local base_flags="--sysroot=$OHOS_NATIVE_HOME/sysroot -fdata-sections -ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes -fno-addrsig -Wa,--noexecstack -fPIC"

    case "$arch" in
      armv7a|armeabi-v7a)
          OHOS_ARCH="armeabi-v7a"
          OHOS_TARGET="arm-linux-ohos"
          OPENSSL_ARCH="linux-armv4"
          FF_EXTRA_CFLAGS="--target=$OHOS_TARGET $base_flags -march=armv7a"
          FF_CFLAGS="--target=$OHOS_TARGET $base_flags -march=armv7a"
          ;;
      armv8|armv8a|aarch64|arm64|arm64-v8a)
          OHOS_ARCH="arm64"
          OHOS_TARGET="aarch64-linux-ohos"
          OPENSSL_ARCH="linux-aarch64"
          FF_EXTRA_CFLAGS="--target=$OHOS_TARGET $base_flags"
          FF_CFLAGS="--target=$OHOS_TARGET $base_flags"
          ;;
      x86_64|x64)
          OHOS_ARCH="x86_64"
          OHOS_TARGET="x86_64-linux-ohos"
          OPENSSL_ARCH="linux-x86_64"
          FF_EXTRA_CFLAGS="--target=$OHOS_TARGET $base_flags"
          FF_CFLAGS="--target=$OHOS_TARGET $base_flags"
          ;;
      *)
        echo "ERROR: Unknown architecture $1"
        exit 1
        ;;
    esac

    # 工具链
    TOOLCHAIN="$OHOS_NATIVE_HOME/llvm"
    SYS_ROOT="$OHOS_NATIVE_HOME/sysroot"
    CC="$TOOLCHAIN/bin/clang"
    CXX="$TOOLCHAIN/bin/clang++"
    LD="$TOOLCHAIN/bin/ld-lld"
    AS="$TOOLCHAIN/bin/llvm-as"
    AR="$TOOLCHAIN/bin/llvm-ar"
    NM="$TOOLCHAIN/bin/llvm-nm"
    RANLIB="$TOOLCHAIN/bin/llvm-ranlib"
    STRIP="$TOOLCHAIN/bin/llvm-strip"

    echo "OHOS_NATIVE_HOME=$OHOS_NATIVE_HOME"
    echo "THE_ARCH=$arch"
}

# 构建OpenSSL库
function build_OpenSSL {
  ARCH=$1

  echo "Building OpenSSL for $ARCH"
  configure_architecture "$ARCH"

  LIBS_DIR="$SCRIPT_DIR/libs/openssl"
  PREFIX="$LIBS_DIR/$OHOS_ARCH"

  echo "PREFIX=$PREFIX"

  export CC="$CC"
  export CXX="$CXX"
  export CXXFLAGS="$FF_EXTRA_CFLAGS"
  export CFLAGS="$FF_CFLAGS"
  export AR="$AR"
  export LD="$LD"
  export AS="$AS"
  export NM="$NM"
  export RANLIB="$RANLIB"
  export STRIP="$STRIP"
  export LDFLAGS="--rtlib=compiler-rt -fuse-ld=lld"

  # 确保目录存在
  mkdir -p "$LIBS_DIR"

  cd "$SCRIPT_DIR/openssl"

  ./Configure "$OPENSSL_ARCH" --prefix="$PREFIX" no-engine no-asm no-threads shared

  make clean
  make depend
  make -j$(nproc) build_libs
  make -j$(nproc) install_sw
  cd "$SCRIPT_DIR"
}

# 构建不同架构的OpenSSL库
build_OpenSSL "armeabi-v7a"
build_OpenSSL "arm64-v8a"