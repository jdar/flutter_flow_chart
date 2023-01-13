import 'package:flutter/material.dart';

import '../elements/flow_element.dart';
import 'element_text_widget.dart';

/// A kind of element
class RoomAllWidget extends StatelessWidget {
  final FlowElement element;
  final IconData widgetIcon;

  const RoomAllWidget({
    Key? key,
    required this.element,
    this.widgetIcon = Icons.abc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: element.size.width,
      height: element.size.height,
      child: Stack(
        children: [
          CustomPaint(
            size: element.size,
            painter: _RoomAllPainter(
              element: element,
              widgetIcon: widgetIcon,
            ),
          ),
          ElementTextWidget(element: element),
        ],
      ),
    );
  }
}

class _RoomAllPainter extends CustomPainter {
  final FlowElement element;
  final IconData widgetIcon;

  _RoomAllPainter({required this.element, required this.widgetIcon});

  @override
  void paint(Canvas canvas, Size size) {
    final icon = widgetIcon;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            color: element.borderColor,
            fontSize: 80.0,
            fontFamily: icon.fontFamily));
    textPainter.layout();
    textPainter.paint(canvas, Offset(10.0, 10.0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
