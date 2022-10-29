import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/widgets.dart';

import 'style.dart';
import 'strings.dart';
import 'utils.dart';
import 'service.dart';

enum ModalState {
  prompt,
  downloading,
  readyToInstall,
}

class UpdateModalContent extends StatefulWidget {
  final double width;
  final double height;
  final UpdateModalContentService service;
  final UpdateInfo info;
  final bool autoInstall;
  final ModalState? initialState;
  final UpdateModalContentStyle? style;
  final UpdateModalStrings? strings;
  final bool dismissable;
  const UpdateModalContent({
    super.key,
    required this.service,
    required this.info,
    this.autoInstall = true,
    this.width = 260,
    this.height = 280,
    this.initialState,
    this.style,
    this.strings,
    this.dismissable = true,
  });
  @override
  createState() => UpdateModalContentState();
}

class UpdateModalContentState extends State<UpdateModalContent> {
  double get width => widget.width;
  double get height => widget.height;
  UpdateModalContentService get service => widget.service;
  bool get autoInstall => widget.autoInstall;
  UpdateInfo get info => widget.info;
  UpdateModalContentStyle? get style => widget.style;
  UpdateModalStrings? get strings => widget.strings;
  var defaultStyle = UpdateModalContentStyle.defaultStyle;
  final defaultStrings = UpdateModalStrings.zhCN;

  var percent = 0;
  var state = ModalState.prompt;
  StreamSubscription? _sub;

  forceUpdate() => setState(() {});

  @override
  void initState() {
    super.initState();
    state = [ModalState.prompt, ModalState.readyToInstall]
            .contains(widget.initialState)
        ? widget.initialState!
        : ModalState.prompt;
    forceUpdate();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _sub = null;
    super.dispose();
  }

  void onDownload() {
    if (state != ModalState.prompt) return;
    _sub?.cancel();
    state = ModalState.downloading;
    service.startDownload().then((stream) {
      _sub = stream.listen((progress) {
        percent = min(100, progress);
        if (progress > 100) {
          state = ModalState.readyToInstall;
          _sub?.cancel();
          _sub = null;
          if (autoInstall) service.install();
        }
        forceUpdate();
      });
    });
    forceUpdate();
  }

  void onAbortDownload() {
    if (state != ModalState.downloading) return;
    service.cancelDownload().then((_) {
      _sub?.cancel();
      _sub = null;
      state = ModalState.prompt;
      forceUpdate();
    });
  }

  void onInstall() {
    if (state != ModalState.readyToInstall) return;
    service.install();
  }

  void onDismiss() async {
    if (state == ModalState.downloading) {
      service.cancelDownload();
      _sub?.cancel();
      _sub = null;
    }
    service.dismiss();
  }

  Widget button({
    Key? key,
    required String text,
    required Function() onTap,
    bool bold = false,
  }) {
    final buttonTextStyle = TextStyle(
      color: style?.buttonTextColor ?? defaultStyle.titleColor!,
      fontSize: style?.buttonTextSize ?? defaultStyle.buttonTextSize!,
      fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: style?.buttonBgColor ?? defaultStyle.buttonBgColor!,
          border: Border.all(
            color: style?.borderColor ?? defaultStyle.borderColor!,
          ),
        ),
        child: Text(
          text,
          style: buttonTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  List<Widget> promptActions() {
    return [
      button(
          text: "${strings?.dismiss ?? defaultStrings.dismiss}",
          onTap: withThrottle(onDismiss)),
      button(
          text: "${strings?.upgrade ?? defaultStrings.upgrade}",
          bold: true,
          onTap: withThrottle(onDownload)),
    ].skip(widget.dismissable ? 0 : 1).toList(growable: false);
  }

  List<Widget> downloadingActions() {
    return [
      button(
          text: "${strings?.dismiss ?? defaultStrings.dismiss}",
          onTap: withThrottle(onDismiss)),
      button(text: "$percent %", bold: true, onTap: () => 0),
    ].skip(widget.dismissable ? 0 : 1).toList(growable: false);
  }

  List<Widget> readyToInstallActions() {
    return [
      button(
          text: "${strings?.dismiss ?? defaultStrings.dismiss}",
          onTap: withThrottle(onDismiss)),
      button(
          text: "${strings?.install ?? defaultStrings.install}",
          bold: true,
          onTap: withThrottle(onInstall)),
    ].skip(widget.dismissable ? 0 : 1).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    defaultStyle = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? UpdateModalContentStyle.dark
        : UpdateModalContentStyle.light;
    final titleStyle = TextStyle(
      color: style?.titleColor ?? defaultStyle.titleColor!,
      fontSize: style?.titleSize ?? defaultStyle.titleSize!,
      fontWeight: FontWeight.w700,
    );
    final infoStyle = TextStyle(
      color: style?.infoColor ?? defaultStyle.infoColor!,
      fontSize: style?.infoSize ?? defaultStyle.infoSize!,
    );
    final descriptionStyle = TextStyle(
      color: style?.descriptionColor ?? defaultStyle.descriptionColor!,
      fontSize: style?.descriptionSize ?? defaultStyle.descriptionSize!,
    );
    final title = Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: style?.borderColor ?? defaultStyle.borderColor!,
          ),
        ),
      ),
      child: Text(
        "${info.name ?? ""}${info.version ?? ""}",
        style: titleStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${strings?.version ?? defaultStrings.version}: ${info.version ?? "-"}",
          style: infoStyle,
          maxLines: 1,
        ),
        Text(
          "${strings?.size ?? defaultStrings.size}: ${info.size ?? "-"}",
          style: infoStyle,
          maxLines: 1,
        ),
        Text(
          "${strings?.releasedAt ?? defaultStrings.releasedAt}: ${info.releasedAt ?? "-"}",
          style: infoStyle,
          maxLines: 1,
        ),
        const SizedBox(height: 8),
        Text("${strings?.description ?? defaultStrings.description}: ",
            style: descriptionStyle),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            children: [
              Text(
                info.description ?? "${info.name ?? ""}${info.version ?? ""}",
                style: descriptionStyle,
              )
            ],
          ),
        ),
      ],
    );
    List<Widget> actions = [];
    switch (state) {
      case ModalState.prompt:
        actions = promptActions();
        break;
      case ModalState.downloading:
        actions = downloadingActions();
        break;
      case ModalState.readyToInstall:
        actions = readyToInstallActions();
        break;
    }
    return Container(
      width: width,
      height: height,
      color: style?.bgColor ?? defaultStyle.bgColor!,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        title,
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: content,
          ),
        ),
        Row(
            children: actions
                .map((el) => Expanded(child: el))
                .toList(growable: false)),
      ]),
    );
  }
}
