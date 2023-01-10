import 'package:flutter/material.dart';

import '../elements/flow_element.dart';
import 'element_text_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoomClosetWidget extends StatelessWidget {
  final FlowElement element;

  const RoomClosetWidget({
    Key? key,
    required this.element,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: element.size.width,
      height: element.size.height,
      child: Stack(
        children: <Widget>[
          SvgPicture.asset(
            'lib/assets/home.svg',
            package: 'flutter_flow_chart',
            color: element.borderColor.withOpacity(0.5),
          ),
          ElementTextWidget(element: element),
        ],
      ),
    );
  }
}
