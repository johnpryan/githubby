@HtmlImport('gh_repos.html')
library githubby.gh_repos;

import 'dart:async';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:githubby/context.dart';
import 'package:githubby/displayable.dart';

import 'package:githubby/components/gh_repo.dart';

DisplayableUser _displayableUser(u) => new DisplayableUser(u);
List<DisplayableUser> _displayableUsers(List us)
  => us.map(_displayableUser).toList();

/// [GhRepo]
@PolymerRegister('gh-repos')
class GhRepos extends PolymerElement {

  Context _context;

  @Property()
  bool hasStorage = true;

  @Property()
  List<DisplayableRepo> repos;

  @Property()
  bool isLoading = false;

  GhRepos.created() : super.created();

  void set context(Context c) {
    _context = c;
    _loadRepos();
  }

  reload() {
    set('repos', []);
    _loadRepos();
  }

  Future _loadRepos() async {
    var storage = _context.storage;
    if (!storage.hasData || storage.workspace.authToken == '') {
      set('hasStorage', false);
    } else {
      set ('hasStorage', true);
    }

    set('isLoading', true);

    var service = _context.service;
    var repos = await service.loadRepos();

    List<DisplayableRepo> displayableRepos = [];

    for (var repo in repos) {
      var displayable = new DisplayableRepo(repo);
      var pullRequests = await service.loadPullRequests(repo.slug());
      for (var pr in pullRequests) {

        var displayablePr = new DisplayablePullRequest(pr);
        var plusOnesRemaining = await service.getPlusOnesRemaining(pr);
        displayablePr.unreviewedCommitCount = plusOnesRemaining.unreviewedCommits;
        var usersToReview = plusOnesRemaining.remainingUsers;
        var taggedUsers = plusOnesRemaining.taggedUsers;
        var fyidUsers = plusOnesRemaining.fyidUsers;
        var displayableUsers = _displayableUsers(usersToReview);
        var displayableTagged = _displayableUsers(taggedUsers);
        var displayableFyid = _displayableUsers(fyidUsers);

        displayablePr.usersToReview = displayableUsers;
        displayablePr.taggedUsers = displayableTagged;
        displayablePr.fyidUsers = displayableFyid;
        displayable.pullRequests.add(displayablePr);
      }
      displayableRepos.add(displayable);
    }

    set('isLoading', false);
    set('repos', displayableRepos);
  }
}
