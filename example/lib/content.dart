import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';

import 'service.dart';

enum ModalState {
  prompt,
  downloading,
  readyToInstall,
}

class UpdaterModalContentStyle {
  static UpdaterModalContentStyle defaultStyle() {
    return UpdaterModalContentStyle()
      ..bgColor = const Color(0xFFFFFFFF)
      ..titleSize = 18.0
      ..titleColor = const Color(0xFF000000)
      ..infoSize = 14.0
      ..infoColor = const Color(0xFF8D8D8D)
      ..descriptionSize = 14.0
      ..descriptionColor = const Color(0xFF000000)
      ..buttonTextSize = 16.0
      ..buttonBgColor = const Color(0xFFFFFFFF)
      ..buttonTextColor = const Color(0xFF000000)
      ..borderColor = const Color(0xFFDEDEDE);
  }

  Color? bgColor;
  double? titleSize;
  Color? titleColor;
  double? infoSize;
  Color? infoColor;
  double? descriptionSize;
  Color? descriptionColor;
  double? buttonTextSize;
  Color? buttonBgColor;
  Color? buttonTextColor;
  Color? borderColor;
}

class UpdaterModalContent extends StatefulWidget {
  final double width;
  final double height;
  final UpdateModalService service;
  final UpdateInfo info;
  final bool autoInstall;
  final UpdaterModalContentStyle? style;
  final ModalState? initialState;
  const UpdaterModalContent({
    super.key,
    required this.service,
    required this.info,
    this.autoInstall = true,
    this.width = 300,
    this.height = 280,
    this.initialState,
    this.style,
  });
  @override
  createState() => UpdaterModalContentState();
}

class UpdaterModalContentState extends State<UpdaterModalContent> {
  double get width => widget.width;
  double get height => widget.height;
  UpdateModalService get service => widget.service;
  bool get autoInstall => widget.autoInstall;
  UpdateInfo get info => widget.info;
  UpdaterModalContentStyle get style =>
      widget.style ?? UpdaterModalContentStyle.defaultStyle();
  final defaultStyle = UpdaterModalContentStyle.defaultStyle();

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

  void onDismiss() {
    service.dismiss();
  }

  Widget button({
    Key? key,
    required String text,
    required Function() onTap,
    bool bold = false,
  }) {
    final buttonTextStyle = TextStyle(
      color: style.buttonTextColor ?? defaultStyle.titleColor!,
      fontSize: style.buttonTextSize ?? defaultStyle.buttonTextSize!,
      fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: style.buttonBgColor ?? defaultStyle.buttonBgColor!,
          border: Border.all(
            color: style.borderColor ?? defaultStyle.borderColor!,
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
      button(text: "以后再说", onTap: onDismiss),
      button(text: "立即更新", bold: true, onTap: onDownload),
    ];
  }

  List<Widget> downloadingActions() {
    return [
      button(text: "取消", onTap: onAbortDownload),
      button(text: "$percent %", bold: true, onTap: () => 0),
    ];
  }

  List<Widget> readyToInstallActions() {
    return [
      button(text: "以后再说", onTap: onDismiss),
      button(text: "安装", bold: true, onTap: onDownload),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      color: style.titleColor ?? defaultStyle.titleColor!,
      fontSize: style.titleSize ?? defaultStyle.titleSize!,
      fontWeight: FontWeight.w700,
    );
    final infoStyle = TextStyle(
      color: style.infoColor ?? defaultStyle.infoColor!,
      fontSize: style.infoSize ?? defaultStyle.infoSize!,
    );
    final descriptionStyle = TextStyle(
      color: style.descriptionColor ?? defaultStyle.descriptionColor!,
      fontSize: style.descriptionSize ?? defaultStyle.descriptionSize!,
    );
    final title = Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: style.borderColor ?? defaultStyle.borderColor!,
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
          "版本: ${info.version ?? "-"}",
          style: infoStyle,
          maxLines: 1,
        ),
        Text(
          "包大小: ${info.size ?? "-"}",
          style: infoStyle,
          maxLines: 1,
        ),
        Text(
          "发布时间: ${info.releasedAt ?? "-"}",
          style: infoStyle,
          maxLines: 1,
        ),
        const SizedBox(height: 5),
        Text("更新说明: ", style: descriptionStyle),
        const SizedBox(height: 5),
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
      color: style.bgColor ?? defaultStyle.bgColor!,
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
