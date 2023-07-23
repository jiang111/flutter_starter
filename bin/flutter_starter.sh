#!/bin/sh
flutterVersion=$(flutter --version)
if [[ $flutterVersion =~ "Flutter" ]]; then
  echo "flutter已安装"
else
  echo "请先安装flutter"
  exit 0
fi

echo -n "请输入项目名称:"
read projectName
echo -n "请输入项目包名:"
read packageName
echo "正在创建 $projectName :"
flutter create --org $packageName $projectName
echo "正在初始化 $projectName :"
cd $projectName
echo "正在初始化基础架构代码:"
cp -r /Users/newtab/AndroidStudioProjects/flutter_starter/lib/* ./lib/
echo "正在调整文件内容:"
sed -i "" -e "s/package:flutter_starter\//package:$projectName\//g" $(find ./lib/* -type f -maxdepth 0 -print)
echo "正在初始化Readme:"
cp -r /Users/newtab/AndroidStudioProjects/flutter_starter/README.md ./
cp -r /Users/newtab/AndroidStudioProjects/flutter_starter/USAGE.md ./
echo "正在初始化pubspec.yaml:"
cp -r /Users/newtab/AndroidStudioProjects/flutter_starter/pubspec.yaml ./pubspec.yaml
echo "正在调整pubspec.yaml:"
sed -i "" "s/flutter_starter/$projectName/g" ./pubspec.yaml
flutter packages get
echo "项目创建成功。"
open .
exit 0
