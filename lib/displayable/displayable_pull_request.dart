library githubby.model.displayable_pull_request;

import 'package:github/common.dart';
import 'package:polymer/polymer.dart';

class DisplayablePullRequest extends PullRequest with JsProxy {

  PullRequest _internal;

  @reflectable
  String get username => _internal.user.name;

  @reflectable
  String get title => _internal.title;

  @reflectable
  String get htmlUrl => _internal.htmlUrl;

  @reflectable
  List<String> usersToReview;

  DisplayablePullRequest(this._internal);
}
