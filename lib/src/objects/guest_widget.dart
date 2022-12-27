import 'package:flutter/material.dart';

import '../elements/flow_element.dart';
import 'element_text_widget.dart';

/// A kind of element
class GuestWidget extends StatelessWidget {
  final FlowElement element;

  const GuestWidget({
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
            painter: _GuestPainter(
              element: element,
            ),
          ),
          ElementTextWidget(element: element),
        ],
      ),
    );
  }
}

class _GuestPainter extends CustomPainter {
  final FlowElement element;

  _GuestPainter({
    required this.element,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final icon = Icons.airline_seat_individual_suite_outlined;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            backgroundColor: element.borderColor,
            color: element.backgroundColor,
            fontSize: 40.0,
            fontFamily: icon.fontFamily));
    textPainter.layout();
    textPainter.paint(canvas, Offset(0.0, -50.0));

/*
    final Paint paint = Paint();
    Path path = Path();

    paint.style = PaintingStyle.fill;
    paint.color = element.backgroundColor;

    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    if (element.elevation > 0.01) {
      canvas.drawShadow(
        path.shift(Offset(element.elevation, element.elevation)),
        Colors.black,
        element.elevation,
        true,
      );
    }
    canvas.drawPath(path, paint);

    paint.strokeWidth = element.borderThickness;
    paint.color = element.borderColor;
    paint.style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
*/
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
