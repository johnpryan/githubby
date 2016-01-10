library githubby.storage_browser;

import 'dart:async';
import 'dart:html' as html;
import 'dart:convert';
import 'package:githubby/model/workspace.dart';
import 'package:githubby/model/storage.dart';

html.Storage _localStorage = html.window.localStorage;
const String _key = 'githubby';

class StorageBrowser implements Storage {
  Workspace workspace;
  bool get _hasExisting => _localStorage.containsKey(_key);

  Future load() async {
    if (!_hasExisting) return;
    var jsonStr = _localStorage[_key];
    var json = JSON.decode(jsonStr);
    workspace = new Workspace.fromJson(json);
  }

  Future save() async {
    _localStorage[_key] = JSON.encode(workspace);
  }

  Future clear() async {
    _localStorage.remove(_key);
  }
}
