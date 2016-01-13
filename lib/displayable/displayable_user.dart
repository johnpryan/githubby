library githubby.model.displayable_repo;

import 'package:github/common.dart';
import 'package:polymer/polymer.dart';

class DisplayableUser extends User with JsProxy {

  User _internal;

  @reflectable
  String get login => _internal.login;

  @reflectable
  String get htmlUrl => _internal.htmlUrl;

  DisplayableUser(this._internal);
}
