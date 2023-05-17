import 'package:flutter/material.dart';

class HoverBox extends StatefulWidget {
  final Widget? child;
  final Widget Function(BuildContext, bool, Widget?) builder;
  const HoverBox({
    super.key,
    required this.child,
    required this.builder,
  });

  @override
  _HoverBox createState() => _HoverBox();
}

class _HoverBox extends State<HoverBox> {
  final ValueNotifier<bool> isInside = ValueNotifier<bool>(false);

  void _onEnter(PointerEvent details) {
    isInside.value = true;
  }

  void _onExit(PointerEvent details) {
    isInside.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: ValueListenableBuilder(
        valueListenable: isInside,
        child: widget.child,
        builder: (
          BuildContext context,
          bool isHover,
          Widget? child,
        ) {
          return widget.builder(context, isHover, child);
        },
      ),
    );
  }
}
