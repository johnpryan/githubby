library githubby.storage_browser;

import 'dart:async';
import 'dart:html' as html;
import 'dart:convert';
import 'package:githubby/model/workspace.dart';
import 'package:githubby/storage.dart';

html.Storage _localStorage = html.window.localStorage;

class StorageBrowser implements Storage {
  String _key;

  Workspace workspace;
  bool get hasData => _localStorage.containsKey(_key);

  StorageBrowser({String uniqueKey: 'githubby'}) {
    _key = uniqueKey;
  }

  Future load() async {
    var jsonStr = _localStorage[_key];
    var json = JSON.decode(jsonStr);
    workspace = new Workspace.fromJson(json);
  }

  Future save() async {
    var json = JSON.encode(workspace);
    _localStorage[_key] = json;
  }

  Future clear() async {
    _localStorage.remove(_key);
  }
}
