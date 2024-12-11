import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpu_management/core/dev/logger.dart';
import 'package:cpu_management/core/utils/utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hive/hive.dart';

/// A Singleton class for Firebase Analytics
class OneCAnalytics {
  static final OneCAnalytics _singleton = OneCAnalytics._internal();
  var firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> _currentUserActionStack = [];
  final List<Map<String, dynamic>> _currentUserErrorStack = [];

  factory OneCAnalytics() {
    return _singleton;
  }

  OneCAnalytics._internal();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  void logEvent(String name,
      {Map<String, String>? parameters = const {}}) async {
    parameters!.addEntries({
      MapEntry('time', DateTime.now().toIso8601String()),
    });
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  void addToCurrentUserActionStack(Map<String, dynamic> name) {
    name.addEntries({
      MapEntry('time', DateTime.now().hhmms),
    });
    _currentUserActionStack.add({
      name['action']: name,
    });
  }

  void addToCurrentUserErrorStack(Map<String, dynamic> name) {
    name.addEntries({
      MapEntry('time', DateTime.now().hhmms),
    });
    _currentUserErrorStack.add(name);
  }

  /// Treating this function as a session
  ///
  /// Only calling when the app terminated
  Future<void> sendCurrentUserActionStack() async {
    logDebug('User action stack: $_currentUserActionStack');
    await storeSession(_currentUserActionStack);
    if (_currentUserActionStack.isEmpty) return;
    Map<String, String> params = {};
    for (int i = 0; i < _currentUserActionStack.length; i++) {
      params.addEntries({
        MapEntry('step_${i + 1}', _currentUserActionStack[i].toString()),
      });
    }
    params.addEntries({
      MapEntry('time', '${DateTime.now().ddMMMyyyy},${DateTime.now().hhmms}')
    });
    logDebug('User action params: $params');

    await _analytics.logEvent(
      name: 'user_action_session_stack',
      parameters: params,
    );
    _currentUserActionStack.clear();
  }

  Future<void> storeSession(List<Map<String, dynamic>> steps) async {
    if (steps.isEmpty && _currentUserErrorStack.isEmpty) return;
    // get user id from hive storeage
    String userId = Hive.box<String>('user').get('user_id') ?? '';
    var userBox = Hive.box<String>('user');
    var userData = userBox.get('user');
    var userInfo = jsonDecode(userData ?? "{}");
    try {
      // Reference to the 'session' collection
      CollectionReference sessionCollection = firestore.collection('sessions');

      // Document reference with userId as the document ID
      DocumentReference userDocRef =
          sessionCollection.doc('$userId/user-sessions/${DateTime.now()}');

      DocumentReference userDetailsRef = sessionCollection.doc(userId);

      var data = {
        'steps': steps,
        'time': '${DateTime.now().ddMMMyyyy},${DateTime.now().hhmms}',
        'userId': userId,
        'formattedTime': DateTime.now().toIso8601String(),
        'errors': _currentUserErrorStack,
      };

      await userDocRef.set(data);
      await userDetailsRef.set(userInfo.toJson());

      logDebug('Session data stored successfully.');
    } catch (e) {
      logError('Error storing session data: $e');
    }
  }

  void setCurrentUserId(String id) {
    _analytics.setUserId(id: id);
  }
}
