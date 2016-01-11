library githubby.context;

import 'package:githubby/model/storage.dart';

/// a singleton application context for each view
/// to use for data
class Context {

  Storage storage;

  static Context _sharedContext;

  Context._internal();

  factory Context() {
    if (_sharedContext == null) {
      _sharedContext = new Context._internal();
    }
    return _sharedContext;
  }
}
