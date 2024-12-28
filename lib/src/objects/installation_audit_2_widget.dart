import 'package:flutter/material.dart';

import '../elements/flow_element.dart';
import 'element_text_widget.dart';

/// A kind of element
class InstallationAudit2Widget extends StatelessWidget {
  final FlowElement element;

  const InstallationAudit2Widget({
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
            painter: _Painter(
              element: element,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: FractionallySizedBox(
              widthFactor: 0.125,
              heightFactor: 0.125,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text("2",
                    //style: TextStyle(fontSize: 40, color: element.borderColor)),
                    style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Impact',
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic)),
              ),
            ),
          ),
          ElementTextWidget(element: element),
        ],
      ),
    );
  }
}

class _Painter extends CustomPainter {
  final FlowElement element;

  _Painter({
    required this.element,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final icon = Icons.find_replace_outlined;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            color: element.borderColor,
            fontSize: 80.0,
            fontFamily: icon.fontFamily));
    textPainter.layout();
    textPainter.paint(canvas, Offset(0.0, -10.0));

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
