library githubby.model.displayable_pull_request;

import 'package:githubby/displayable.dart';

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
  User get user => _internal.user;

  @reflectable
  int get number => _internal.number;

  @reflectable
  int unreviewedCommitCount;

  @reflectable
  List<DisplayableUser> usersToReview;

  @reflectable
  bool get hasUsersToReview => usersToReview.length > 0;

  @reflectable
  List<DisplayableUser> taggedUsers;

  @reflectable
  bool get hasTagged => taggedUsers.length > 0;

  @reflectable
  bool get canMerge {
    return hasTagged && !hasUsersToReview;
  }

  @reflectable get displayReviewers => !canMerge && hasTagged;

  @reflectable
  List<DisplayableUser> fyidUsers;

  @reflectable
  bool hide = false;

  DisplayablePullRequest(this._internal);
}
