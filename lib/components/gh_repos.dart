@HtmlImport('gh_repos.html')
library githubby.gh_repos;

import 'dart:async';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:githubby/context.dart';
import 'package:githubby/displayable.dart';

import 'package:githubby/components/gh_repo.dart';

/// [GhRepo]
@PolymerRegister('gh-repos')
class GhRepos extends PolymerElement {

  Context _context;

  @Property()
  bool hasStorage = true;

  @Property()
  List<DisplayableRepo> repos;

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
    if (!storage.hasData) {
      _displayStorageError();
      return;
    }

    var service = _context.service;
    var repos = await service.loadRepos();

    List<DisplayableRepo> displayableRepos = [];

    for (var repo in repos) {
      var displayable = new DisplayableRepo(repo);
      var pullRequests = await service.loadPullRequests(repo.slug());
      for (var pr in pullRequests) {
        var displayablePr = new DisplayablePullRequest(pr);
        var usersToReview = await service.getUsersToReview(pr);
        displayablePr.usersToReview = usersToReview;
        displayable.pullRequests.add(displayablePr);
      }
      displayableRepos.add(displayable);
    }

    set('repos', displayableRepos);
  }

  _displayStorageError() {
    hasStorage = false;
  }
}
