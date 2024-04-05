# 指定CMake的最小版本
cmake_minimum_required(VERSION 3.27.8)
# 工程名称，这里我们就叫ohos_tutorial
project(ohos_tutorial)

set(CMAKE_CXX_STANDARD 17)

function(include_sub_directories_recursively root_dir)
    if (IS_DIRECTORY ${root_dir})               # 当前路径是一个目录吗，是的话就加入到包含目录
        if (${root_dir} MATCHES ".git")
            return()
        endif()
        if (${root_dir} MATCHES ".svn" OR ${root_dir} MATCHES ".idea" OR  ${root_dir} MATCHES "cmake-build-debug" )
            return()
        endif()
        #        if (${root_dir} MATCHES "include")
        message("include dir: " ${root_dir})
        include_directories(${root_dir})
        #        endif()
    endif()

    file(GLOB ALL_SUB RELATIVE ${root_dir} ${root_dir}/*) # 获得当前目录下的所有文件，让如ALL_SUB列表中
    foreach(sub ${ALL_SUB})
        if (IS_DIRECTORY ${root_dir}/${sub})
            include_sub_directories_recursively(${root_dir}/${sub}) # 对子目录递归调用，包含
        endif()
    endforeach()
endfunction()

# 自动递归的动态解析代码
# include_sub_directories_recursively(${PROJECT_SOURCE_DIR})
# file(GLOB_RECURSE SOURCES RELATIVE ${PROJECT_SOURCE_DIR} *.h *.cpp )
# message("SOURCES = "${SOURCES})


#添加一个子目录并构建该子目录。
ADD_SUBDIRECTORY(src)
