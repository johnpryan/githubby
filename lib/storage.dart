library githubby.storage;

import 'dart:async';
import 'package:githubby/model/workspace.dart';

abstract class Storage {
  Workspace get workspace;
  Future load();
  Future save();
  Future clear();
}
