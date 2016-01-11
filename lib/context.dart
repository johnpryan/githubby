library githubby.context;

import 'dart:async';

import 'package:githubby/browser_storage.dart';
import 'package:githubby/browser_services.dart';

/// a singleton application context for each view
/// to use for data
class Context {

  BrowserStorage storage;
  BrowserService service;

  static Context _sharedContext;

  Context._internal();

  factory Context() {
    if (_sharedContext == null) {
      _sharedContext = new Context._internal();
    }
    return _sharedContext;
  }

  Future initialize() async {
    storage = new BrowserStorage();
    await storage.load();
    service = new BrowserService(storage.workspace);
    service.loadAuth();
  }

  Future clearWorkspace() async {
    await storage.clear();
    service.workspace = storage.workspace;
    service.loadAuth();
  }
}
