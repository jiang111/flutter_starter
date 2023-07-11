## 打印日志

```agsl
import 'extension_log.dart';
"请求出错".e();
"请求出错".w();
```

## loading对话框展示

```agsl
import 'extension_easy_loading.dart';
"请稍等...".eLoading();
"成功".eSuccess();
"失败".eFail();
"吐司".toast();

```

## 本地存储SP

```agsl
SpUtil.put();
```

## 分页请求

```agsl
BaseList<String>(
        builder: (context, data, _) => ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return ListTile(
              title: Text(item),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(
            height: 1,
          ),
        ),
        provider: listProvider,
      )


final listProvider = AsyncNotifierProvider.autoDispose.family<ListNotify, List<String>, BaseListBean>(
  () => ListNotify(),
  name: 'listProvider',
);

class ListNotify extends BaseListNotify<String> {
  @override
  Future<List<String>> fetchPage(int page) async {
    return Future.delayed(const Duration(seconds: 1), () {
      return List.generate(pageSize, (index) => "$index");
    });
  }
}
```


## iOS的plist文件配置
```agsl
	<key>NSMicrophoneUsageDescription</key>
    <string>App需要您的同意,才能访问麦克风</string>
	<key>NSCameraUsageDescription</key>
	<string>若不允许，你将无法拍照</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>若不允许，你将无法上传及保存相册照片</string>
	<key>UIApplicationSupportsIndirectInputEvents</key>
	<true/>


```