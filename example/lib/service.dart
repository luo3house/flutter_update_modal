class UpdateInfo {
  String? name;
  String? version;
  String? size;
  String? releasedAt;
  String? description;
}

abstract class UpdateModalWithCheckerService extends UpdateModalService {
  Future<UpdateInfo?> checkUpdate();
}

abstract class UpdateModalService {
  Future<Stream<int>> startDownload();
  Future<int> cancelDownload();
  Future<int> dismiss();
  Future<int> install();
}

class SimpleUpdateModalService implements UpdateModalWithCheckerService {
  Future<UpdateInfo?> Function()? checkUpdateImpl;
  Future<Stream<int>> Function()? startDownloadImpl;
  Future<int> Function()? cancelDownloadImpl;
  Future<int> Function()? dismissImpl;
  Future<int> Function()? installImpl;
  @override
  Future<Stream<int>> startDownload() async {
    if (startDownloadImpl != null) {
      return await startDownloadImpl!();
    }
    throw UnimplementedError();
  }

  @override
  Future<int> cancelDownload() async {
    if (cancelDownloadImpl != null) {
      return await cancelDownloadImpl!();
    }
    throw UnimplementedError();
  }

  @override
  Future<int> dismiss() async {
    if (dismissImpl != null) {
      return await dismissImpl!();
    }
    throw UnimplementedError();
  }

  @override
  Future<int> install() async {
    if (installImpl != null) {
      return await installImpl!();
    }
    throw UnimplementedError();
  }

  @override
  Future<UpdateInfo?> checkUpdate() async {
    if (installImpl != null) {
      return await checkUpdateImpl!();
    }
    throw UnimplementedError();
  }
}
