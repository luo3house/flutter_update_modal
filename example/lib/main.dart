import 'package:flutter/cupertino.dart';
import 'package:update_modal/update_modal.dart';

void main() {
  runApp(const CupertinoApp(
    title: 'Flutter Demo',
    home: const MyApp(),
  ));
}

class UpdateModalServiceImpl implements UpdateModalService {
  @override
  Future<int> cancelDownload() {
    return Future.value(0);
  }

  @override
  Future<UpdateInfo> checkUpdate() {
    final info = UpdateInfo()
      ..name = "ExampleUpdaterApp"
      ..version = "3.2.0"
      ..size = "13.6M"
      ..releasedAt = "2022-10-26 22:20:01"
      ..description = """
ExampleUpdaterAppExampleUpdaterAppExampleUpdaterAppExampleUpdaterAppExampleUpdaterApp
ExampleUpdaterApp
ExampleUpdaterApp
ExampleUpdaterApp
ExampleUpdaterApp
ExampleUpdaterApp
ExampleUpdaterApp
""";
    return Future.delayed(Duration(milliseconds: 300), () => info);
  }

  @override
  Future<int> dismiss() {
    return Future.value(0);
  }

  @override
  Future<int> install() {
    return Future.value(0);
  }

  @override
  Future<Stream<int>> startDownload() {
    return Future.value(Stream.fromFutures([
      Future.delayed(Duration(milliseconds: 150 * 1), () => 20),
      Future.delayed(Duration(milliseconds: 150 * 2), () => 40),
      Future.delayed(Duration(milliseconds: 150 * 3), () => 60),
      Future.delayed(Duration(milliseconds: 150 * 4), () => 80),
      Future.delayed(Duration(milliseconds: 150 * 5), () => 100),
      Future.delayed(Duration(milliseconds: 150 * 6), () => 120),
    ]));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  Widget buildCupertino(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CupertinoButton(
            child: const Text("Check Update"),
            onPressed: () {
              UpdateModal.init(
                context,
                service: UpdateModalServiceImpl(),
              );
            },
          ),
          CupertinoButton(
            child: const Text("Check Update (NOT dismissable)"),
            onPressed: () {
              UpdateModal.init(
                context,
                service: UpdateModalServiceImpl(),
                dismissable: false,
              );
            },
          ),
          CupertinoButton(
            child: const Text("Check Update (i18N)"),
            onPressed: () {
              UpdateModal.init(
                context,
                service: UpdateModalServiceImpl(),
                strings: UpdateModalStrings()
                  ..dismiss = "Later"
                  ..upgrade = "Upgrade Now"
                  ..install = "Install Now"
                  ..version = "Version"
                  ..size = "App Size"
                  ..releasedAt = "Release Date"
                  ..description = "Description",
              );
            },
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildCupertino(context);
  }
}
