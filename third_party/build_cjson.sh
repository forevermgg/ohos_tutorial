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

cd cJson
mkdir -p ohos64build

cd ohos64build
cmake -DCMAKE_TOOLCHAIN_FILE=$OHOS_NATIVE_HOME/build/cmake/ohos.toolchain.cmake  .. -L
make

ls