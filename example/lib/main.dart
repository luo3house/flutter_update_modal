import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:update_modal/update_modal.dart';

void main() {
  // runApp(MaterialApp(
  //   title: 'Flutter Demo',
  //   theme: ThemeData(primarySwatch: Colors.blue),
  //   home: const MyApp(material: true),
  // ));
  runApp(const CupertinoApp(
    title: 'Flutter Demo',
    home: MyApp(material: false),
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
    return Future.delayed(Duration(seconds: 1), () => info);
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
  final bool material;
  const MyApp({super.key, required this.material});
  @override
  createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  Widget buildMaterial(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Check Update"),
          onPressed: () {
            UpdateModal.init(
              context,
              service: UpdateModalServiceImpl(),
            );
          },
        ),
      ),
    );
  }

  Widget buildCupertino(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoButton(
        child: const Text("Check Update"),
        onPressed: () {
          UpdateModal.init(
            context,
            service: UpdateModalServiceImpl(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.material ? buildMaterial(context) : buildCupertino(context);
  }
}
