library githubby.model.displayable_repo;

import 'package:githubby/displayable.dart';

import 'package:github/common.dart';
import 'package:polymer/polymer.dart';

class DisplayableRepo extends Repository with JsProxy {

  Repository _internal;

  @reflectable
  String get fullName => _internal.fullName;

  @reflectable
  String get htmlUrl => _internal.htmlUrl;

  @reflectable
  List<DisplayablePullRequest> pullRequests = [];

  @reflectable
  bool hide = false;

  DisplayableRepo(this._internal);
}
