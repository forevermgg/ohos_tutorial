# https://gitee.com/openharmony/docs/tree/master/zh-cn/release-notes
# wget https://repo.huaweicloud.com/openharmony/os/4.0-Release/L2-SDK-MAC-M1-PUBLIC.tar.gz
# tar -xvzf L2-SDK-MAC-M1-PUBLIC.tar.gz
echo "> 获得当前目录" $(pwd)
current_platform=$(uname -a | tr '[:upper:]' '[:lower:]')
echo "> platform" "$current_platform"
echo "> system" "$(uname -s)"

workspace=$(pwd)
echo "当前目录: ${workspace}"

mac_ohos_sdk_dir="${workspace}/mac-sdk-full/sdk/packages"
echo "mac_ohos_sdk_dir目录: ${mac_ohos_sdk_dir}"

unzip_ohos_sdk() {
  local platform=$1
  local open_harmony_dir=$2
  echo "platform: ${platform}"
  echo "open_harmony_dir: ${open_harmony_dir}"
  ohos_sdk_zip_dir="${open_harmony_dir}/ohos-sdk/${platform}"
  if [ -d "${ohos_sdk_zip_dir}" ]; then
     echo "Directory '${ohos_sdk_zip_dir}' exist."
     cd "${ohos_sdk_zip_dir}" || exit
     echo "当前目录: $(pwd)"
     zip_files=$(find "${ohos_sdk_zip_dir}" -type f -name "*.zip")
     for zip_file in ${zip_files}
     do
         echo "ohos_sdk_zip_dir_zip_files: ${zip_file}"
         unzip -o "${zip_file}" -d${ohos_sdk_zip_dir}
     done
  else
     echo "Directory '${ohos_sdk_zip_dir}' does not exist."
  fi
}

unzip_ohos_sdk "darwin" "${mac_ohos_sdk_dir}"