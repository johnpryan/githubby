library githubby.model.repo;

import 'package:github/common.dart';
import 'package:polymer/polymer.dart';

class Repo extends Repository with JsProxy {

  Repository _internal;

  @reflectable
  String get fullName => _internal.fullName;

  @reflectable
  String get htmlUrl => _internal.htmlUrl;

  Repo(this._internal);
}
