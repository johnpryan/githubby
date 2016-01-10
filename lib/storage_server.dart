library githubby.storage_server;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:githubby/model/workspace.dart';
import 'package:githubby/model/storage.dart';

const String filename = '.githubby';

class StorageServer implements Storage {
  Workspace workspace;

  File _file;
  Future<bool> get _hasExisting async => _file.exists();

  StorageServer() {
    var homeDir = Platform.environment['HOME'];
    _file = new File('$homeDir/$filename');
  }

  Future load() async {
    if (!await _hasExisting) return;

    var fileString = await _file.readAsString();
    var fileJson = JSON.decode(fileString);
    workspace = new Workspace.fromJson(fileJson);
  }

  Future save() async {
    await _file.writeAsString(JSON.encode(workspace.toJson()));
  }

  Future clear() async {
    await _file.delete();
  }
}
