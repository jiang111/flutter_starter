#!/bin/bash
export LANG=en_US.UTF-8
red='\033[0;31m'
red() { echo -e "\033[31m\033[01m$1\033[0m"; }
green() { echo -e "\033[32m\033[01m$1\033[0m"; }
yellow() { echo -e "\033[33m\033[01m$1\033[0m"; }
readp() { read -p "$(yellow "$1")" $2; }
### 运行脚本: bash script/build_web.sh
### 或者：支持 3 个参数同时传入，分别是：flutter 环境(1.flutter, 2.fvm)、web 环境(1.dev 2.dev2, 3.release)、字体缓存(1.下载字体，2不下载)
### 例如：bash script/build_web.sh 1 2 1

# 判断当前目录是否为项目根目录
if [ ! -f "pubspec.yaml" ]; then
  red "错误：当前目录不是项目根目录，请在项目根目录执行此脚本。 命令: bash ./script/build_web.sh"
  exit 1
fi
if [ $# == 3 ]; then
  chooseFlutterEnv=$1
  chooseEnv=$2
  chooseFontCache=$3
# 判断当前目录是否为项目根目录
else
  if [ $# == 3 ]; then
    chooseFlutterEnv=$1
    chooseEnv=$2
    chooseFontCache=$3
  else
    green "请选择你的 Flutter 开发环境:"
    readp "1. 使用标准 Flutter 环境(默认)\n2. 使用 fvm 环境 \n请选择：" chooseFlutterEnv

    # 如果用户输入为空，则默认赋值为1
    if [ -z "$chooseFlutterEnv" ]; then
      chooseFlutterEnv=1
    fi

    if ! [[ "$chooseFlutterEnv" =~ ^[0-9]+$ ]]; then
      red "错误：请输入一个有效的整数值。"
      exit 1
    fi

    if [ "$chooseFlutterEnv" -gt 2 ]; then
      red "错误：输入的值大于2，请输入2或更小的值。"
      exit 1
    fi

    green "请选择你构建 web 的环境:"
    readp "1. 1套\n2. 2套(默认) \n3. 线上环境 \n请选择：" chooseEnv

    if [ -z "$chooseEnv" ]; then
      chooseEnv=2
    fi

    if ! [[ "$chooseEnv" =~ ^[0-9]+$ ]]; then
      red "错误：请输入一个有效的整数值。"
      exit 1
    fi

    if [ "$chooseEnv" -gt 3 ]; then
      red "错误：输入的值大于3，请输入3或更小的值。"
      exit 1
    fi

    green "请选择本地是否已缓存 gstatic 网站的字体库:"
    readp "1. 自动判断(默认)\n2. 已缓存 \n请选择：" chooseFontCache

    if [ -z "$chooseFontCache" ]; then
      chooseFontCache=1
    fi
  fi
fi
# 如果chooseEnv==3，那么强制chooseFontCache为 1
if [ "$chooseEnv" == "3" ]; then
  chooseFontCache=1
  red "你选择了线上环境，已强制选择自动判断本地字体缓存情况\n\n"
fi

if ! [[ "$chooseFontCache" =~ ^[0-9]+$ ]]; then
  red "错误：请输入一个有效的整数值。"
  exit 1
fi
if [ "$chooseFontCache" -gt 2 ]; then
  red "错误：输入的值大于2，请输入2或更小的值。"
  exit 1
fi

if [ "$chooseFontCache" == "1" ]; then
  chooseFontCache=false
elif [ "$chooseFontCache" == "2" ]; then
  chooseFontCache=true
fi

green "你选择的条件如下:\n"

if [ "$chooseFlutterEnv" == "2" ]; then
  red "fvm 环境"
else
  red "标准 Flutter 环境"
fi

if [ "$chooseEnv" == "1" ]; then
  red "构建 web 1套"
elif [ "$chooseEnv" == "2" ]; then
  red "构建 web 2套"
else
  red "构建 web 线上环境"
fi

if [ "$chooseFontCache" == "true" ]; then
  red "本地字体已缓存"
else
  red "自动判断本地字体缓存情况"
fi

# 定义 command
if [ "$chooseFlutterEnv" == "2" ]; then
  command="fvm flutter"
else
  command="flutter"
fi

red "\n请确认以上信息是否正确,3秒后开始构建"
sleep 3

if [ "$chooseEnv" == "1" ]; then
  green "开始构建 测试服"
  $command pub get
  $command build web --release --web-renderer canvaskit --no-tree-shake-icons --target ./lib/main.dart
  green "开始检查字体库并解决浏览器强刷问题, 请耐心等待"
  dart ./script/patch.dart http://test.baidu.com $chooseFontCache
elif [ "$chooseEnv" == "2" ]; then
  green "开始构建 2套"
  $command pub get
  $command build web --release --web-renderer canvaskit --no-tree-shake-icons --target ./lib/main.dart
  green "开始检查字体库并解决浏览器强刷问题, 请耐心等待"
  dart ./script/patch.dart http://test.baidu.com $chooseFontCache
else
  green "开始构建 线上环境"
  $command pub get
  $command build web --release --web-renderer canvaskit --no-tree-shake-icons --target ./lib/main.dart
  green "开始检查字体库并解决浏览器强刷问题, 请耐心等待"
  dart ./script/patch.dart http://test.baidu.com $chooseFontCache
fi

green "构建完成"
