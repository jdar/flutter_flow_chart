// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import 'elements/connection_params.dart';
import 'ui/draw_arrow.dart';
import 'elements/flow_element.dart';
import 'ui/grid_background.dart';

/// Class to store all the scene elements.
/// It notifies changes to [FlowChart]
class Dashboard extends ChangeNotifier {
  late List<FlowElement> elements;
  late Offset dashboardPosition;
  late Size dashboardSize;
  late Offset handlerFeedbackOffset;
  late GridBackgroundParams gridBackgroundParams;
  late DateTime modifiedAt;
  late String projectJson;
  late ChangeNotifier observeDeeply = ChangeNotifier();

  Dashboard() {
    elements = [];
    modifiedAt = DateTime.now();
    projectJson = "{}";
    dashboardPosition = Offset.zero;
    dashboardSize = const Size(0, 0);
    handlerFeedbackOffset = const Offset(-40, -40);
    gridBackgroundParams = const GridBackgroundParams();
    observeDeeply.addListener(() {
      modifiedAt = DateTime.now();
    });
  }

  /// set grid background parameters
  setGridBackgroundParams(GridBackgroundParams params) {
    gridBackgroundParams = params;
    notifyListeners();
  }

  /// set the feedback offset to help on mobile device to see the
  /// end of arrow and not hiding behind the finger when moving it
  setHandlerFeedbackOffset(Offset offset) {
    handlerFeedbackOffset = offset;
  }

  /// set [isResizable] element property
  setElementResizable(FlowElement element, bool resizable) {
    element.isResizing = resizable;
    notifyListeners();
  }

  /// add a [FlowElement] to the dashboard
  addElement(FlowElement element, {bool notify = true}) {
    if (element.id.isEmpty) {
      element.id = const Uuid().v4();
    }
    elements.add(element);
    if (notify) {
      element.addListener(() {
        observeDeeply.notifyListeners();
      });

      observeDeeply.notifyListeners();
      notifyListeners();
    }
  }

  /// find the element by its [id]
  int findElementIndexById(String id) {
    return elements.indexWhere((element) => element.id == id);
  }

  /// remove all elements
  removeAllElements() {
    elements.clear();

    observeDeeply.notifyListeners();
    notifyListeners();
  }

  /// remove the [handler] connection of [element]
  removeElementConnection(FlowElement element, Handler handler) {
    Alignment alignment;
    switch (handler) {
      case Handler.topCenter:
        alignment = const Alignment(0.0, -1.0);
        break;
      case Handler.bottomCenter:
        alignment = const Alignment(0.0, 1.0);
        break;
      case Handler.leftCenter:
        alignment = const Alignment(-1.0, 0.0);
        break;
      case Handler.rightCenter:
      default:
        alignment = const Alignment(1.0, 0.0);
    }
    element.next.removeWhere((handlerParam) =>
        handlerParam.arrowParams.startArrowPosition == alignment);

    element.addListener(() {
      observeDeeply.notifyListeners();
    });

    observeDeeply.notifyListeners();
    notifyListeners();
  }

  /// remove all the connection from the [element]
  removeElementConnections(FlowElement element) {
    element.next.clear();

    element.addListener(() {
      observeDeeply.notifyListeners();
    });

    observeDeeply.notifyListeners();
    notifyListeners();
  }

  /// remove all the elements with [id] from the dashboard
  removeElementById(String id) {
    // remove the element
    String elementId = '';
    elements.removeWhere((element) {
      if (element.id == id) {
        elementId = element.id;
        element.addListener(() {
          observeDeeply.notifyListeners();
        });
      }
      return element.id == id;
    });

    // remove all connections to the elements found
    for (FlowElement e in elements) {
      e.next.removeWhere((handlerParams) {
        return elementId.contains(handlerParams.destElementId);
      });
    }

    observeDeeply.notifyListeners();
    notifyListeners();
  }

  /// remove element
  /// return true if it has been removed
  bool removeElement(FlowElement element) {
    // remove the element
    bool found = false;
    String elementId = element.id;
    elements.removeWhere((e) {
      if (e.id == element.id) {
        found = true;
        element.addListener(() {
          observeDeeply.notifyListeners();
        });
      }
      return e.id == element.id;
    });

    // remove all connections to the element
    for (FlowElement e in elements) {
      e.next.removeWhere(
          (handlerParams) => handlerParams.destElementId == elementId);
    }
    if (found) {
      observeDeeply.notifyListeners();
      notifyListeners();
    }
    return found;
  }

  /// needed to know the diagram widget position to compute
  /// offsets for drag and drop elements
  setDashboardPosition(Offset position) {
    dashboardPosition = position;
  }

  /// needed to know the diagram widget size
  setDashboardSize(Size size) {
    dashboardSize = size;
  }

  /// make an arrow connection from [sourceElement] to
  /// the elements with id [destId]
  /// [arrowParams] definition of arrow parameters
  addNextById(FlowElement sourceElement, String destId, ArrowParams arrowParams,
      {bool notify = true}) {
    int found = 0;
    for (int i = 0; i < elements.length; i++) {
      if (elements[i].id == destId) {
        // if the [id] already exist, remove it and add this new connection
        sourceElement.next
            .removeWhere((element) => element.destElementId == destId);
        sourceElement.next.add(ConnectionParams(
          destElementId: elements[i].id,
          arrowParams: arrowParams,
        ));

        found++;
      }
    }

    if (found == 0) {
      debugPrint('Element with $destId id not found!');
      return;
    }
    if (notify) {
      observeDeeply.notifyListeners();
      notifyListeners();
    }
  }

  //******************************* */
  /// manage load/save using json
  Map<String, dynamic> toMap(Size canvassSize) {
    return <String, dynamic>{
      'elements': elements.map((x) => x.toMap(canvassSize)).toList(),
      'projectJson': projectJson,
    };
  }

  factory Dashboard.fromMap(Map<String, dynamic> map, Size canvassSize) {
    Dashboard d = Dashboard();
    d.elements = List<FlowElement>.from(
      (map['elements'] as List<dynamic>).map<FlowElement>(
        (x) => FlowElement.fromMap((x as Map<String, dynamic>), canvassSize),
      ),
    );
    d.modifiedAt = map['modifiedAt'] == null
        ? DateTime.now()
        : DateTime.parse(map['modifiedAt']);
    //projectJson: keep track of other random json, but it's not for the library, so don't deserialize or otherwise handle logic.
    d.projectJson = map['projectJson'] == null ? '{}' : map['projectJson'];
    return d;
  }

  String toJson(Size canvassSize) => json.encode(toMap(canvassSize));

  factory Dashboard.fromJson(String source, Size canvassSize) =>
      Dashboard.fromMap(
          json.decode(source) as Map<String, dynamic>, canvassSize);

  String prettyJson(
      Size canvassSize, Map<String, dynamic> domainOptionalParameters) {
    var spaces = ' ' * 2;
    var encoder = JsonEncoder.withIndent(spaces);
    var _map = toMap(canvassSize)..addEntries(domainOptionalParameters.entries);
    return encoder.convert(_map);
  }

  /// save the dashboard into [completeFilePath]
  saveDashboard(String completeFilePath, Size canvassSize) {
    File f = File(completeFilePath);
    f.writeAsStringSync(prettyJson(canvassSize, {}), flush: true);
  }

  saveDashboardWithDomainOptionalParameters(String completeFilePath,
      Size canvassSize, Map<String, dynamic> domainOptionalParameters) {
    File f = File(completeFilePath);
    f.writeAsStringSync(prettyJson(canvassSize, domainOptionalParameters),
        flush: true);
  }

  /// clear the dashboard and load the new one
  loadDashboard(String completeFilePath, Size canvassSize) {
    File f = File(completeFilePath);
    if (f.existsSync()) {
      elements.clear();
      String source = f.readAsStringSync();

      List<FlowElement> all = List<FlowElement>.from(
        ((json.decode(source))['elements'] as List<dynamic>).map<FlowElement>(
          (x) => FlowElement.fromMap(x as Map<String, dynamic>, canvassSize),
        ),
      );
      var alreadyAddedBackgroundElement = false;
      for (int i = 0; i < all.length; i++) {
        var el = all.elementAt(i);
        if (el.kind == ElementKind.house && alreadyAddedBackgroundElement) {
          //don't double up. Fix previous logic error in the wild.
        } else {
          addElement(el);
        }
      }

      observeDeeply.notifyListeners();
      notifyListeners();
    }
  }
}
