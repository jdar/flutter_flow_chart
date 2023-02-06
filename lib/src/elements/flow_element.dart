import 'dart:convert';

import 'package:flutter/material.dart';

import 'connection_params.dart';

enum ElementKind {
  rectangle,
  diamond,
  storage,
  oval,
  person,
  senior_man,
  senior_woman,
  man,
  woman,
  youth,
  parallelogram,

  notes,

//room
  kitchen,
  // living_room,
  // laundry_room,
  office_sala,
  other_indoor,
  other_outdoor,
  // closet,
  bedroom,
  bathroom,

//appliances
  microwave,
  appliance_other,

//other
  house,
  house_condition,
  electrical,
  solicitation,
  contract,
//bills
  bills_electric,
  bills_phone,
  bills_water,
//survey
  survey,
}

enum Handler {
  topCenter,
  bottomCenter,
  rightCenter,
  leftCenter,
}

/// Class to store [ElementWidget]s and notify its changes
class FlowElement extends ChangeNotifier {
  /// Unique id set when adding a [FlowElement] with [Dashboard.addElement()]
  String id;

  /// The position of the [FlowElement]
  Offset position;

  /// The size of the [FlowElement]
  Size size;

  /// Element text
  String text;

  /// Text color
  Color textColor;

  /// Text size
  double textSize;

  /// Makes text bold if true
  bool textIsBold;

  /// Element data
  Map<String, dynamic> data;

  /// Element shape
  ElementKind kind;

  /// Connection handlers
  List<Handler> handlers;

  /// The size of element handlers
  double handlerSize;

  /// Background color of the element
  Color backgroundColor;

  /// Border color of the element
  Color borderColor;

  /// Border thickness of the element
  double borderThickness;

  /// Shadow elevation
  double elevation;

  /// List of connections of this element
  List<ConnectionParams> next;

  /// Element text
  bool isResizing;

  FlowElement({
    this.position = Offset.zero,
    this.size = Size.zero,
    this.text = '',
    this.textColor = Colors.black,
    this.textSize = 18,
    this.textIsBold = false,
    this.data = const <String, String>{},
    this.kind = ElementKind.rectangle,
    this.handlers = const [
      Handler.topCenter,
      Handler.bottomCenter,
      Handler.rightCenter,
      Handler.leftCenter,
    ],
    this.handlerSize = 15.0,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.blue,
    this.borderThickness = 3,
    this.elevation = 4,
    next,
  })  : next = next ?? [],
        id = '',
        isResizing = false;

  @override
  String toString() {
    return 'kind: $kind  text: $text';
  }

  /// When setting to true, a handler will disply at the element bottom right
  /// to let the user to resize it. When finish it will disappear.
  setIsResizing(bool resizing) {
    isResizing = resizing;
    notifyListeners();
  }

  /// Used internally to set an unique Uuid to this element
  setId(String id) {
    this.id = id;
  }

  /// Set text
  setText(String text) {
    this.text = text;
    notifyListeners();
  }

  /// Set text color
  setTextColor(Color color) {
    textColor = color;
    notifyListeners();
  }

  /// Set text size
  setTextSize(double size) {
    textSize = size;
    notifyListeners();
  }

  /// Set text bold
  setTextIsBold(bool isBold) {
    textIsBold = isBold;
    notifyListeners();
  }

  /// Set data
  setData(Map<String, dynamic> data) {
    this.data = data;
    notifyListeners();
  }

  /// Set background color
  setBackgroundColor(Color color) {
    backgroundColor = color;
    notifyListeners();
  }

  /// Set border color
  setBorderColor(Color color) {
    borderColor = color;
    notifyListeners();
  }

  /// Set border thickness
  setBorderThickness(double thickness) {
    borderThickness = thickness;
    notifyListeners();
  }

  /// Set elevation
  setElevation(double elevation) {
    this.elevation = elevation;
    notifyListeners();
  }

  /// Change element position in the dashboard
  changePosition(Offset newPosition) {
    position = newPosition;
    notifyListeners();
  }

  /// Change element size
  changeSize(Size newSize) {
    if (newSize.width < 40) newSize = Size(40, newSize.height);
    if (newSize.height < 40) newSize = Size(newSize.width, 40);
    size = newSize;
    notifyListeners();
  }

  bool hasOther(String dataKey) {
    return data.containsKey(dataKey) && data[dataKey].contains('other');
  }

  dynamic rawValue(String dataKey, dynamic defaultValue) {
    if (data.containsKey(dataKey)) {
      return data[dataKey];
    }
    return defaultValue;
  }

  String get param {
    return '${kind.name}_${id}';
  }

  @override
  bool operator ==(covariant FlowElement other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  //like supplying toEncodeable, sort of.
  String tryJsonEncode(Map<String, dynamic> foo) {
    var out = <String, dynamic>{};
    for (var e in foo.entries) {
      var _k = e.key;
      try {
        if (_k.endsWith('_list') ||
            _k.endsWith('_multiselect') ||
            _k.endsWith('_filter')) {
          out[e.key] = jsonEncode(e.value);
        } else if (_k.endsWith('_date') ||
            _k.endsWith('_at') ||
            _k.endsWith('_time')) {
          out[_k] = e.value.toString();
        } else if (e.key.endsWith('range_slider')) {
          var r = e.value as RangeValues;
          out[_k] = '${r.start}:${r.end}';
        } else if (e.key.endsWith('_range')) {
          var r = e.value as RangeValues;
          out[_k] = '${r.start}:${r.end}';
        } else {
          jsonEncode(e.value);
          out[_k] = e.value;
        }
      } catch (err) {
        print('$e: $err ');
      }
    }
    return jsonEncode(out);
  }

  static Map<String, dynamic> tryJsonDecode(dynamic obj) {
    String jsonData = '';
    try {
      jsonData = obj as String;
    } catch (_) {
      print('not a string');
      return <String, dynamic>{};
    }

    print('is string');

    return jsonDecode(jsonData, reviver: (k, v) {
      if (k is List) {
        return <String>[];
      }
      if (k == null) {
        //why is reviver being run on the fully-decoded list? Must be recursive.
        return v;
      }
      if (k is int) return v;
      var _k = k as String;
      if (_k.endsWith('_list') ||
          _k.endsWith('_multiselect') ||
          _k.endsWith('_filter')) {
        var vs = jsonDecode(v as String);
        return vs;
      } else if (_k.endsWith('range_date')) {
        print('range date');
        return DateTime.tryParse(v as String);
      } else if (_k.endsWith('_date') ||
          _k.endsWith('_at') ||
          _k.endsWith('_time')) {
        print('range date');
        return DateTime.tryParse(v as String);
      } else if (_k.endsWith('_range')) {
        var vs = (v as String).split(':');
        return RangeValues(double.parse(vs[0]), double.parse(vs[1]));
      }
      return v;
    });
  }

  @override
  int get hashCode {
    return position.hashCode ^
        size.hashCode ^
        text.hashCode ^
        textColor.hashCode ^
        textSize.hashCode ^
        textIsBold.hashCode ^
        tryJsonEncode(data).hashCode ^ //TODO: benchmark
        id.hashCode ^
        kind.hashCode ^
        handlers.hashCode ^
        handlerSize.hashCode ^
        backgroundColor.hashCode ^
        borderColor.hashCode ^
        borderThickness.hashCode ^
        elevation.hashCode ^
        next.hashCode;
  }

  Map<String, dynamic> toMap(Size canvassSize) {
    return <String, dynamic>{
      'positionDx': (position.dx / canvassSize.width),
      'positionDy': (position.dy / canvassSize.height),
      'size.width': size.width,
      'size.height': size.height,
      'text': text,
      'textColor': textColor.value,
      'textSize': textSize,
      'textIsBold': textIsBold,
      'jsonData': tryJsonEncode(data),
      'id': id,
      'kind': kind.index,
      'handlers': handlers.map((x) => x.index).toList(),
      'handlerSize': handlerSize,
      'backgroundColor': backgroundColor.value,
      'borderColor': borderColor.value,
      'borderThickness': borderThickness,
      'elevation': elevation,
      'next': next.map((x) => x.toMap()).toList(),
    };
  }

  factory FlowElement.fromMap(Map<String, dynamic> map, Size canvassSize) {
    FlowElement e = FlowElement(
      position: Offset(
        (map['positionDx'] as double) * canvassSize.width,
        (map['positionDy'] as double) * canvassSize.height,
      ),
      size: Size(map['size.width'] as double, map['size.height'] as double),
      text: map['text'] as String,
      textColor: Color(map['textColor'] as int),
      textSize: map['textSize'] as double,
      textIsBold: map['textIsBold'] as bool,
      //data: FlowElement.tryJsonDecode(map['jsonData'] as String),
      data: FlowElement.tryJsonDecode(map['jsonData']),
      kind: ElementKind.values[map['kind'] as int],
      handlers: List<Handler>.from(
        (map['handlers'] as List<dynamic>).map<Handler>(
          (x) => Handler.values[x],
        ),
      ),
      handlerSize: map['handlerSize'] as double,
      backgroundColor: Color(map['backgroundColor'] as int),
      borderColor: Color(map['borderColor'] as int),
      borderThickness: map['borderThickness'] as double,
      elevation: map['elevation'] as double,
      next: List<ConnectionParams>.from(
        (map['next'] as List<dynamic>).map<dynamic>(
          (x) => ConnectionParams.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
    e.setId(map['id'] as String);
    return e;
  }

  String toJson(Size canvassSize) => json.encode(toMap(canvassSize));

  factory FlowElement.fromJson(String source, Size canvassSize) =>
      FlowElement.fromMap(
          json.decode(source) as Map<String, dynamic>, canvassSize);
}
