# shellcheck disable=SC2164
echo "Only user $(whoami) can run this script."
rm -rf build
mkdir build && cd build
cmake -DOHOS_STL=c++_shared -DOHOS_ARCH=arm64-v8a -DOHOS_PLATFORM=OHOS -DCMAKE_TOOLCHAIN_FILE=/Users/$(whoami)/CLionProjects/ohos_tutorial/mac-sdk-full/sdk/packages/ohos-sdk/darwin/native/build/cmake/ohos.toolchain.cmake ..
cmake --build .

# 参数解释：
# OHOS_STL：默认c++_shared，可选c++_static
# OHOS_ARCH: 默认arm64-v8a，可选armeabi-v7a、x86_64
# OHOS_PLATFORM：仅支持OHOS
# CMAKE_TOOLCHAIN_FILE：cmake的工具链的配置文件所在路径