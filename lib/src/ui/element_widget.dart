import 'package:flutter/material.dart';
import 'package:flutter_flow_chart/src/objects/oval_widget.dart';

//person
import 'package:flutter_flow_chart/src/objects/person_widget.dart';
//and subtypes
import 'package:flutter_flow_chart/src/objects/man_widget.dart';
import 'package:flutter_flow_chart/src/objects/woman_widget.dart';
import 'package:flutter_flow_chart/src/objects/senior_woman_widget.dart';
import 'package:flutter_flow_chart/src/objects/senior_man_widget.dart';
import 'package:flutter_flow_chart/src/objects/youth_widget.dart';
import 'package:flutter_flow_chart/src/objects/kitchen_widget.dart';
import 'package:flutter_flow_chart/src/objects/appliance_microwave_widget.dart';
import 'package:flutter_flow_chart/src/objects/house_widget.dart';

import '../../flutter_flow_chart.dart';
import '../objects/parallelogram_widget.dart';
import 'element_handlers.dart';
import '../objects/diamond_widget.dart';
import '../objects/rectangle_widget.dart';
import '../objects/storage_widget.dart';
import 'resize_widget.dart';

/// Widget that use [element] properties to display it on the dashboard scene
class ElementWidget extends StatefulWidget {
  final Dashboard dashboard;
  final FlowElement element;
  final Function(BuildContext context, Offset position)? onElementPressed;
  final Function(BuildContext context, Offset position)? onElementLongPressed;
  final Function(BuildContext context, Offset position)? onDragUpdate;
  final Function(
    BuildContext context,
    Offset position,
    Handler handler,
    FlowElement element,
  )? onHandlerPressed;
  final Function(
    BuildContext context,
    Offset position,
    Handler handler,
    FlowElement element,
  )? onHandlerLongPressed;

  const ElementWidget({
    Key? key,
    required this.dashboard,
    required this.element,
    this.onElementPressed,
    this.onElementLongPressed,
    this.onHandlerPressed,
    this.onHandlerLongPressed,
    this.onDragUpdate,
  }) : super(key: key);

  @override
  State<ElementWidget> createState() => _ElementWidgetState();
}

class _ElementWidgetState extends State<ElementWidget> {
  // local widget touch position when start dragging
  Offset delta = Offset.zero;

  @override
  void initState() {
    super.initState();
    widget.element.addListener(_elementChanged);
  }

  @override
  void dispose() {
    widget.element.removeListener(_elementChanged);
    super.dispose();
  }

  _elementChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget element;

    switch (widget.element.kind) {
      case ElementKind.diamond:
        element = DiamondWidget(element: widget.element);
        break;
      case ElementKind.storage:
        element = StorageWidget(element: widget.element);
        break;
      case ElementKind.oval:
        element = OvalWidget(element: widget.element);
        break;
      case ElementKind.person:
        element = PersonWidget(element: widget.element);
        break;
      case ElementKind.senior_man:
        element = SeniorManWidget(element: widget.element);
        break;
      case ElementKind.senior_woman:
        element = SeniorWomanWidget(element: widget.element);
        break;
      case ElementKind.man:
        element = ManWidget(element: widget.element);
        break;
      case ElementKind.woman:
        element = WomanWidget(element: widget.element);
        break;
      case ElementKind.youth:
        element = YouthWidget(element: widget.element);
        break;

      case ElementKind.parallelogram:
        element = ParallelogramWidget(element: widget.element);
        break;
      case ElementKind.kitchen:
        element = KitchenWidget(element: widget.element);
        break;
      case ElementKind.microwave:
        element = ApplianceMicrowaveWidget(element: widget.element);
        break;
      case ElementKind.house:
        element = HouseWidget(element: widget.element);
        break;
      case ElementKind.rectangle:

      default:
        element = RectangleWidget(element: widget.element);
    }

    if (widget.element.isResizing) {
      return Transform.translate(
        offset: widget.element.position,
        transformHitTests: true,
        child: ResizeWidget(
          element: widget.element,
          dashboard: widget.dashboard,
          child: element,
        ),
      );
    }

    element = Padding(
      padding: EdgeInsets.all(widget.element.handlerSize / 2),
      child: element,
    );

    Offset tapLocation = Offset.zero;
    return Transform.translate(
      offset: widget.element.position,
      transformHitTests: true,
      child: GestureDetector(
        onTapDown: (details) => tapLocation = details.globalPosition,
        onTap: () {
          if (widget.onElementPressed != null) {
            widget.onElementPressed!(context, tapLocation);
          }
        },
        onLongPress: () {
          if (widget.onElementLongPressed != null) {
            widget.onElementLongPressed!(context, tapLocation);
          }
        },
        child: Listener(
          onPointerDown: (event) {
            delta = event.localPosition;
          },
          child: Draggable<FlowElement>(
            data: widget.element,
            dragAnchorStrategy: childDragAnchorStrategy,
            childWhenDragging: const SizedBox.shrink(),
            feedback: Material(
              color: Colors.transparent,
              child: element,
            ),
            child: ElementHandlers(
              dashboard: widget.dashboard,
              element: widget.element,
              handlerSize: widget.element.handlerSize,
              onHandlerPressed: widget.onHandlerPressed,
              onHandlerLongPressed: widget.onHandlerLongPressed,
              child: element,
            ),
            onDragUpdate: (details) {

              widget.onDragUpdate?.call(),
              widget.element.changePosition(details.globalPosition -
                  widget.dashboard.dashboardPosition -
                  delta);
            },
            onDragEnd: (details) {
              widget.element.changePosition(
                  details.offset - widget.dashboard.dashboardPosition);
            },
          ),
        ),
      ),
    );
  }
}
