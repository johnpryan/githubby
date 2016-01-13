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
  DisplayableUser get user => new DisplayableUser(_internal.user);

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
  int get howOld => _internal.createdAt.millisecondsSinceEpoch;

  @reflectable
  String get status {
    if (canMerge) {
      return "Ready to Merge";
    } else if (hasTagged && hasUsersToReview) {
      return "Needs Review";
    } else if (!hasUsersToReview) {
      return "Not Ready";
    } else {
      return "Unkown";
    }
  }

  @reflectable
  String get colorStatus {
    if (canMerge) {
      return "badge-ready";
    } else if (hasTagged && hasUsersToReview) {
      return "badge-review";
    } else if (!hasUsersToReview) {
      return "badge-notready";
    } else {
      return "badge-unknown";
    }
  }

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
