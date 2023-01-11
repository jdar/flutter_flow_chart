import 'package:flutter/material.dart';

import '../elements/flow_element.dart';
import 'element_text_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HouseWidget extends StatelessWidget {
  final FlowElement element;

  const HouseWidget({
    Key? key,
    required this.element,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Stack(children: <Widget>[
          SvgPicture.asset(
            'lib/assets/home.svg',
            package: 'flutter_flow_chart',
            color: Colors.black,
          ),
/* DEBUGGING:
                Positioned.fill(
                  child: Container(
                    color: Colors.blue.withOpacity(0.2),
                    child: LayoutBuilder(builder: (context, constraints) {
                      // Do whatever you want here
                      return Text(constraints.toString());
                    }),
                  ),
                ),
 end DEBUGGING */
        ]),
      ),
    );
  }
}
