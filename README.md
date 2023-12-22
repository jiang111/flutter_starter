# flutter_starter

a flutter template base on myself project (base on 3.16.0)

- ⚡️ [Flutter](https://github.com/flutter/flutter), [Dart](https://github.com/dart-lang) - Build
  apps for any screen

- 🗂 [Router via go_router](https://github.com/flutter/packages/tree/main/packages/go_router)

- 🍍 [State Management via Riverpod](https://github.com/rrousselGit/riverpod)

## packages

- 🎢 [change_app_package_name](https://pub.dev/packages/change_app_package_name)

```agsl
flutter pub run change_app_package_name:main your_package_name
```

- 🎢 [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

```agsl
flutter pub run flutter_launcher_icons:main
```

- 🎢 [flutter_riverpod](https://docs-v2.riverpod.dev/zh-Hans/docs/getting_started)

```agsl
//监听
flutter pub run build_runner watch
```

- 🎢 [how to use](https://github.com/jiang111/flutter_starter/blob/main/USAGE.md)

## build

```agsl
bash script/build_web.sh

make apk

make ipa
```

for more build command see [build_web.sh](script/build_web.sh) <br />
for more build command see [Makefile](./Makefile)<br />

## warning

you should update your keystore file in [build.gradle](android/app/build.gradle) <br />
you should update your target dart file in [Makefile](./Makefile) <br />
you should update your target dart file in [build_web.sh](script/build_web.sh) <br />


