import 'package:easy_refresh/easy_refresh.dart';
import 'package:go_router/go_router.dart';
import 'base.dart';

class Initial {
  static String baseUrl = "";


  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SpUtil.getInstance();
    Http.init(baseUrl: baseUrl);
    configEasyRefresh();
    GoRouter.optionURLReflectsImperativeAPIs = true;
    //全局竖屏处理
    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }
  static void configEasyRefresh() {
    EasyRefresh.defaultHeaderBuilder = () => const ClassicHeader(
      hitOver: true,
      hapticFeedback: true,
      dragText: '下拉刷新',
      armedText: '释放开始',
      readyText: '正在刷新',
      processingText: '正在刷新',
      processedText: '刷新成功',
      messageText: '最后更新于 %T',
      failedText: '失败了',
      showMessage: true,
      spacing: 4,
      progressIndicatorSize: 16,
      iconTheme: IconThemeData(color: Colors.grey, size: 20),
      noMoreIcon: Icon(Icons.info_outlined),
      // noMoreIcon: SizedBox(),
      textStyle: TextStyle(fontSize: 14, color: Colors.grey),
      messageStyle: TextStyle(fontSize: 12, color: Colors.grey),
    );

    EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(
        infiniteHitOver: true,
        dragText: '上拉加载更多',
        armedText: '释放开始',
        readyText: '加载中',
        processingText: '加载中',
        processedText: '加载成功',
        failedText: '失败了',
        noMoreText: '没有更多了',
        noMoreIcon: Icon(Icons.info_outlined),
        messageText: '最后更新于 %T',
        infiniteOffset: 140,
        spacing: 4,
        progressIndicatorSize: 16,
        iconTheme: IconThemeData(color: Colors.grey, size: 20),
        textStyle: TextStyle(fontSize: 14, color: Colors.grey),
        messageStyle: TextStyle(fontSize: 12, color: Colors.grey),
        showMessage: true);
  }

}
