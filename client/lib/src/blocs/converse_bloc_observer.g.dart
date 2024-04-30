import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';

class ConverseBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      print('\n\u001b[1;33m{entity}Bloc.onChanged\u001b[0m');
      final newState = change.nextState.toMap(false).toSingleKeyValues();
      change.currentState
          .toMap(false)
          .toSingleKeyValues()
          .forEach((key, value) {
        if (value != newState[key]) {
          final current = '\u001b[0m$key: \u001b[1;31m$value\u001b[0m ---> ';
          final next = '\u001b[1;32m${newState[key]}';
          // ignore: avoid_print
          print('  $current$next\u001b[0m');
        }
      });
    }
  }
}

// Please don't touch this. Tusi AI Generated
extension DartMapExtension on Map<String, dynamic> {
  Map<String, String> toSingleKeyValues() {
    var finalMap = <String, String>{};

    forEach((key, value) {
      var runType = value.runtimeType.toString();
      if (runType == 'IdentityMap<String, dynamic>' ||
          runType == 'IdentityMap<String, dynamic>') {
        Map<String, dynamic>.from(value).forEach((innerKey, innerValue) {
          var ft = innerValue.runtimeType.toString();
          if (ft.contains('List<Map<String, dynamic>>')) {
            var subMaps = (innerValue as List<Map<String, dynamic>>);
            for (int index = 0; index < subMaps.length; index++) {
              Map<String, dynamic>.from(subMaps[index])
                  .toSingleKeyValues()
                  .forEach((subKey, subValue) {
                finalMap['$key.$innerKey.$index.$subKey'] = subValue;
              });
            }
          } else if (ft.contains('Map<String,')) {
            (innerValue as Map<String, dynamic>)
                .toSingleKeyValues()
                .forEach((subKey, subValue) {
              finalMap['$key.$innerKey.$subKey'] = subValue;
            });
          } else {
            finalMap['$key.$innerKey'] = '$innerValue';
          }
        });
      } else if (runType.contains('List<Map<')) {
        var fieldValues = List<Map<String, dynamic>>.from(value);
        for (int index = 0; index < fieldValues.length; index++) {
          var fieldType = fieldValues[index].runtimeType.toString();
          if (fieldType.contains('Map<String,')) {
            var map = Map<String, dynamic>.from(fieldValues[index])
                .toSingleKeyValues()
                .map((subKey, subValue) {
              return MapEntry('$key.$index.$subKey', subValue);
            });
            finalMap.addAll(map);
          } else {
            fieldValues[index].forEach((fieldKey, fieldValue) {
              finalMap['$key.$index.$fieldKey'] = '$fieldValue';
            });
          }
        }
      } else {
        finalMap[key] = '$value';
      }
    });
    return finalMap;
  }
}
