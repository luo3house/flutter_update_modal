# update_modal

[![Pub Version](https://img.shields.io/pub/v/update_modal)](https://pub.dev/packages/update_modal)
[![Github Action](https://github.com/luo3house/flutter_update_modal/actions/workflows/build-demo.yml/badge.svg)](https://luo3house.github.io/flutter_update_modal/)

Bugly style update modal on flutter. It is based on UI and cross platform.

**Try the [Demo](https://luo3house.github.io/flutter_update_modal/)**

Example project is at `example/`.

![Modal Preview](./image/modal.png)

## Getting Started

### Install

Add dependency to `pubspec.yaml`.

```yaml
dependencies:
  update_modal: ^0.0.3
```

### Implement checker, downloader, installer

```dart
class MyUpdateService implements UpdateModalService {
  @override
  Future<int> cancelDownload() {
    // Perform cancel download, resolve arbitary number
  }

  @override
  Future<UpdateInfo> checkUpdate() async {
    // Perform check update, resolve update info
    // Resolve NULL means no update
    return UpdateInfo()
      ..name = "ExampleUpdaterApp"
      ..version = "3.2.0"
      ..size = "13.6M"
      ..releasedAt = "2022-10-26 22:20:01"
      ..description = "Upgrade description";
  }

  @override
  Future<int> dismiss() {
    // Perform dismiss to cleanup
    return Future.value(0);
  }

  @override
  Future<int> install() {
    // Perform install package
    return Future.value(0);
  }

  @override
  Future<Stream<int>> startDownload() {
    // Perform download, resolve a stream for progress notification
    // When progress > 100(e.g. 101), the modal mark state to readyToInstall
    return Future.value(Stream.fromFutures([
      Future.delayed(Duration(milliseconds: 150 * 1), () => 20),
      Future.delayed(Duration(milliseconds: 150 * 2), () => 40),
      Future.delayed(Duration(milliseconds: 150 * 3), () => 60),
      Future.delayed(Duration(milliseconds: 150 * 4), () => 80),
      Future.delayed(Duration(milliseconds: 150 * 5), () => 100),
      // modal show [Dismiss, Install] once receive progress > 100
      Future.delayed(Duration(milliseconds: 150 * 6), () => 120),
    ]));
  }
}
```

### Perform check at App startup

```dart
class MyApp extends StatefulWidget {
  @override
  createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  initState() {
    UpdateModal.init(
      context,
      service: UpdateModalServiceImpl(),
    );
  }
}
```

## Debugging

Open a web server for cross-platform modal widget debugging.

```bash
Make example
```

or,

```bash
cd example; flutter run -d web-server --web-port=8080
```

## License

MIT
