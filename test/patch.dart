import "package:path/path.dart";
import 'package:dio/dio.dart';
import 'dart:io';

main() async {
  await WebPatch().buildWeb(BuildMode.dev2);
}

enum BuildMode {
  ip("http://192.168.2.16:8080"),
  dev("http://mapptest.baidu.com"),
  dev2("http://mapptest2.baidu.com"),
  release("http://h5.baidu.com");

  final String path;

  const BuildMode(this.path);
}

class WebPatch {
  static const webBuildDir = "build/web";
  List<String> fonts = [];
  List<String> downloadFonts = [];

  DateTime start = DateTime.now();

  void startTime() {
    start = DateTime.now();
  }

  void endTime() {
    var time = DateTime.now().difference(start);

    //根据时间长短转换
    if (time.inSeconds > 0) {
      log("耗时: ${time.inSeconds}秒");
      return;
    }
    if (time.inMilliseconds > 0) {
      log("耗时: ${time.inMilliseconds}毫秒");
      return;
    }
  }

  Future<void> buildWeb(BuildMode buildMode) async {
    log("开始构建 web :");

    startTime();
    String target = _getTargetDartFile(buildMode);
    String entryPoint = join(
      dirname(Platform.script.path),
      "lib",
      target,
    );
    await Process.run('flutter', ["build", "web", "--release", "--target", entryPoint]);
    log("web 构建完成。");

    await patch(buildMode.path);
  }

  Future<void> patch(String host) async {
    fonts.clear();
    downloadFonts.clear();
    log("开始分析 main.dart.js 文件:");
    startTime();
    String mainJsPath = join(
      dirname(Platform.script.path),
      webBuildDir,
      "main.dart.js",
    );
    File file = File(mainJsPath);
    List<String> lines = file.readAsLinesSync();
    String canvasKitUrl = "";
    //获取里面所有的字体
    for (var line in lines) {
      //匹配一下 canvasKit 的 host
      if (canvasKitUrl.isEmpty) {
        String? kit = _regCanvasKit(line);
        if (kit != null) {
          canvasKitUrl = kit;
        }
      }
      //处理所有的字体文件
      await _regFont(line);
    }
    log("共找到了:${fonts.length}个字体,下载了 ${downloadFonts.length} 个字体");

    log("开始替换 font 域名: https://fonts.gstatic.com => $host");
    await _replaceHost("https://fonts.gstatic.com", host);

    log("canvasKit 域名: $canvasKitUrl => $host/canvaskit/\":");
    await _replaceHost(canvasKitUrl, "$host/canvaskit/\":");
    endTime();
    await Process.run('open', [
      join(
        dirname(Platform.script.path),
        webBuildDir,
      )
    ]);
  }

  Future<String?> _findOneFont(String url) async {
    String fileName = join(
      dirname(Platform.script.path),
      webBuildDir,
      url.substring("https://fonts.gstatic.com/".length),
    );
    if (File(fileName).existsSync()) {
      return null;
    }

    return await _download(url, fileName);
  }

  Future<String?> _download(String url, String savePath) async {
    try {
      String tempPath = savePath.substring(0, savePath.lastIndexOf("/"));
      if (!Directory(tempPath).existsSync()) {
        await Directory(tempPath).create(recursive: true);
      }
      var response = await dio.download(url, savePath);
      if (response.statusCode != 200) {
        log("下载失败 url:$url 本地路径:$savePath");
        return null;
      } else {
        return savePath;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<void> _regFont(String line) async {
    RegExp pattern = RegExp(r'"([^"]+\.(?:ttf|otf))"');
    Iterable<Match> matches = pattern.allMatches(line);
    for (var match in matches) {
      String font = (match.group(0) ?? "").replaceAll("\"", "");
      fonts.add(font);
      String url;
      if (font.startsWith("https://fonts.gstatic.com/s/")) {
        url = font;
      } else {
        url = "https://fonts.gstatic.com/s/$font";
      }
      var result = await _findOneFont(url);
      if (result != null) {
        downloadFonts.add(result);
      }
    }
  }

  Future<void> _replaceHost(String oldContent, String newContent) async {
    final file = File(join(dirname(Platform.script.path), webBuildDir, "main.dart.js"));

    final lines = file.readAsLinesSync();
    final updatedLines = lines.map((line) => line.replaceAll(oldContent, newContent));

    file.writeAsStringSync(updatedLines.join('\n'));
  }

  Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 50),
    receiveTimeout: const Duration(seconds: 50),
  ));

  void log(String msg) {
    print(msg);
  }

  String _getTargetDartFile(BuildMode buildMode) {
    if (buildMode == BuildMode.dev) {
      return "main.dart";
    } else if (buildMode == BuildMode.dev2) {
      return "main.dart";
    } else if (buildMode == BuildMode.release) {
      return "main.dart";
    } else if (buildMode == BuildMode.ip) {
      throw Exception("使用 IP 的 buildMode，必须指定 domain");
    } else {
      throw Exception("不支持的域名");
    }
  }

  String? _regCanvasKit(String line) {
    RegExp pattern = RegExp(r'https://www.gstatic.com/flutter-canvaskit[^ ]*/":');
    Match? match = pattern.firstMatch(line);

    if (match != null) {
      String? extracted = match.group(0);
      if (extracted != null) {
        return extracted;
      }
    }
    return null;
  }
}
