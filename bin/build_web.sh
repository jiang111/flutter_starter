echo "开始构建 web:"
flutter build web --release
echo "构建完成"
dart ./bin/patch.dart https://baidu.com
