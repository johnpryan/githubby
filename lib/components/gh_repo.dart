@HtmlImport('gh_repo.html')
library githubby.gh_repo;

import 'dart:html';

import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer/polymer.dart';

import 'package:githubby/displayable.dart';

import 'package:githubby/components/gh_pull_request.dart';

/// [GhPullRequest]
@PolymerRegister('gh-repo')
class GhRepo extends PolymerElement {

  @Property()
  DisplayableRepo repo;

  @Property()
  List<DisplayablePullRequest> pullRequests;

  @Property(observer: 'prsChanged')
  List<DisplayablePullRequest> displayablePullRequests;

  @Property()
  List<DisplayablePullRequest> get pullRequestsToDisplay {
    if (displayablePullRequests == null) return [];
    var displayable = displayablePullRequests.where((pr) {
      return !pr.hide;
    }).toList();
    return displayable;
  }

  @property bool get hide => repo?.hide ?? false;

  GhRepo.created() : super.created();

  ready() {
    window.onHashChange.listen((_) {
      set('pullRequests', pullRequestsToDisplay);
    });
  }

  @reflectable
  prsChanged([_, __]) {
    set('pullRequests', pullRequestsToDisplay);
  }
}
