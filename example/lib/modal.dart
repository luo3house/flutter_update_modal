import 'package:example/content.dart';
import 'package:example/service.dart';
import 'package:flutter/material.dart';

class UpdateModal {
  UpdateModal._();
  static void init(
    BuildContext context, {
    required UpdateModalWithCheckerService service,
  }) {
    dynamic Function() onDismiss = () {};
    final wrappedService = SimpleUpdateModalService()
      ..checkUpdateImpl = service.checkUpdate
      ..startDownloadImpl = service.startDownload
      ..cancelDownloadImpl = service.cancelDownload
      ..installImpl = service.install
      ..dismissImpl = () => service.dismiss().then((value) {
            onDismiss();
            return value;
          });
    wrappedService.checkUpdate().then((info) {
      if (info == null) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          onDismiss = () => Navigator.of(ctx).pop();
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: UpdaterModalContent(service: wrappedService, info: info),
          );
        },
      );
    });
  }
}
