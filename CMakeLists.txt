# 指定CMake的最小版本
cmake_minimum_required(VERSION 3.27.8)
# 工程名称，这里我们就叫ohos_tutorial
project(ohos_tutorial)

set(CMAKE_CXX_STANDARD 17)


#添加一个子目录并构建该子目录。
ADD_SUBDIRECTORY(src)
