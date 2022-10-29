import 'package:flutter/material.dart';
import 'style.dart';
import 'content.dart';
import 'service.dart';
import 'strings.dart';

class UpdateModal {
  UpdateModal._();
  static void init(
    BuildContext context, {
    required UpdateModalService service,
    UpdateModalContentStyle? style,
    UpdateModalStrings? strings,
    bool dismissable = true,
    bool autoInstall = false,
  }) {
    dynamic Function() onDismiss = () {};
    final wrappedService = SimpleUpdateModalService()
      ..checkUpdateImpl = service.checkUpdate
      ..startDownloadImpl = service.startDownload
      ..cancelDownloadImpl = service.cancelDownload
      ..installImpl = (() => service.install().then((value) {
            onDismiss();
            return value;
          }))
      ..dismissImpl = () => service.dismiss().then((value) {
            onDismiss();
            return value;
          });
    wrappedService.checkUpdate().then((info) {
      if (info == null) return;
      final defaultStyle = UpdateModalContentStyle.defaultStyle;
      final content = UpdateModalContent(
        service: wrappedService,
        info: info,
        style: style,
        strings: strings,
        autoInstall: autoInstall,
        dismissable: dismissable,
      );
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: content.style?.maskColor ?? defaultStyle.maskColor!,
        pageBuilder: (x, y, z) {
          onDismiss = () => Navigator.of(x).pop();
          return Center(child: Material(child: content));
        },
      );
    });
  }
}
