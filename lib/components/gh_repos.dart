@HtmlImport('gh_repos.html')
library githubby.gh_repos;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:githubby/context.dart';
import 'package:githubby/displayable.dart';

import 'package:githubby/components/gh_repo.dart';

DisplayableUser _displayableUser(u) => new DisplayableUser(u);
List<DisplayableUser> _displayableUsers(List us) => us.map(_displayableUser).toList();

/// [GhRepo]
@PolymerRegister('gh-repos')
class GhRepos extends PolymerElement {
  Context _context;

  @Property()
  bool hasStorage = true;

  @Property()
  List<DisplayableRepo> repos;

  @Property(observer: 'filterChanged')
  String filter = window.location.hash.replaceFirst('#', '');

  @Property()
  bool isLoading = false;

  @Property()
  bool showBadges;

  List<DisplayableRepo> displayableRepos = [];

  List<DisplayableRepo> get reposToDisplay {
    // set the 'hide' property of each repo and pr
    for (var repo in displayableRepos) {
      var allHidden = true;
      for (var pr in repo.pullRequests) {
        pr.hide = true;

        // handle untagged PRS
        if (pr.usersToReview.isEmpty) {
          if (filter == '') {
            pr.hide = false;
          } else {
            pr.hide = true;
          }
        } else {
          for (var user in pr.usersToReview) {
            if (user.login.contains(filter)) {
              pr.hide = false;
            }
          }
        }

        allHidden = allHidden && pr.hide;
      }
      repo.hide = allHidden;
    }
    var result = displayableRepos.where((repo) {
      return repo.hide == false;
    }).toList();
    return result;
  }

  GhRepos.created() : super.created();

  ready() {
    window.onHashChange.listen((_) {
      set('filter', window.location.hash.replaceFirst('#', ''));
    });
  }

  void set context(Context c) {
    _context = c;
    reload();
  }

  reload() {
    displayableRepos.clear();
    set('showBadges', _context.storage.workspace.showBadges);
    _loadRepos();
  }

  Future _loadRepos() async {
    var storage = _context.storage;
    if (!storage.hasData || storage.workspace.authToken == '') {
      set('hasStorage', false);
    } else {
      set('hasStorage', true);
    }

    set('isLoading', true);

    var service = _context.service;
    var repos = await service.loadRepos();

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
    set('repos', reposToDisplay);
  }

  @reflectable
  filterChanged([_, __]) {
    window.location.hash = filter;
    var toDisplay = reposToDisplay;
    set('repos', toDisplay);
  }
}
