import 'package:flutter/material.dart';

import '../elements/flow_element.dart';
import 'element_text_widget.dart';

/// A kind of element
class YouthWidget extends StatelessWidget {
  final FlowElement element;

  const YouthWidget({
    Key? key,
    required this.element,
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
            painter: _YouthPainter(
              element: element,
            ),
          ),
          ElementTextWidget(element: element),
        ],
      ),
    );
  }
}

class _YouthPainter extends CustomPainter {
  final FlowElement element;

  _YouthPainter({
    required this.element,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final icon = Icons.sports_handball;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            backgroundColor: element.borderColor,
            color: element.backgroundColor,
            fontSize: 40.0,
            fontFamily: icon.fontFamily));
    textPainter.layout();
    textPainter.paint(canvas, Offset(0.0, -10.0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
