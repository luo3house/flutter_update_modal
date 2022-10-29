import 'package:flutter/cupertino.dart';
import 'package:update_modal/update_modal.dart';

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
    return Future.delayed(const Duration(milliseconds: 300), () => info);
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
      Future.delayed(const Duration(milliseconds: 150 * 1), () => 20),
      Future.delayed(const Duration(milliseconds: 150 * 2), () => 40),
      Future.delayed(const Duration(milliseconds: 150 * 3), () => 60),
      Future.delayed(const Duration(milliseconds: 150 * 4), () => 80),
      Future.delayed(const Duration(milliseconds: 150 * 5), () => 100),
      Future.delayed(const Duration(milliseconds: 150 * 6), () => 120),
    ]));
  }
}

void main() {
  runApp(CupertinoApp(
    title: 'Flutter Demo',
    home: Builder(builder: (BuildContext context) {
      return CupertinoPageScaffold(
        child: Center(
          child: ListView(children: [
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
              child: const Text("Check Update (en-US)"),
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
            CupertinoButton(
              child: const Text("Check Update (Light theme)"),
              onPressed: () {
                UpdateModal.init(
                  context,
                  service: UpdateModalServiceImpl(),
                  style: UpdateModalContentStyle.light,
                );
              },
            ),
            CupertinoButton(
              child: const Text("Check Update (Dark theme)"),
              onPressed: () {
                UpdateModal.init(
                  context,
                  service: UpdateModalServiceImpl(),
                  style: UpdateModalContentStyle.dark,
                );
              },
            ),
          ]),
        ),
      );
    }),
  ));
}
