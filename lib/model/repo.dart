library githubby.model.repo;

import 'package:github/common.dart';
import 'package:polymer/polymer.dart';

class Repo extends Repository with JsProxy {

  @reflectable
  String fullName;

}
