import 'package:example/modal.dart';
import 'package:example/service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: MyApp(),
  ));
}

class UpdateModalServiceImpl implements UpdateModalWithCheckerService {
  @override
  Future<int> cancelDownload() {
    return Future.value(0);
  }

  @override
  Future<UpdateInfo> checkUpdate() {
    return Future.value(
      UpdateInfo()
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
""",
    );
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
      Future.delayed(Duration(milliseconds: 50 * 1), () => 20),
      Future.delayed(Duration(milliseconds: 50 * 2), () => 40),
      Future.delayed(Duration(milliseconds: 50 * 3), () => 60),
      Future.delayed(Duration(milliseconds: 50 * 4), () => 80),
      Future.delayed(Duration(milliseconds: 50 * 5), () => 100),
      Future.delayed(Duration(milliseconds: 50 * 6), () => 120),
    ]));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      UpdateModal.init(
        context,
        service: UpdateModalServiceImpl(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF555555),
      body: Text("Demo"),
    );
  }
}
