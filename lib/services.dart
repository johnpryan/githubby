library githubby.service;

import 'dart:async';

import 'package:github/common.dart';

import 'package:githubby/model.dart';

bool _validRepo(String r) => r != null && r != '';
RepositorySlug _stringToSlug(String r) => new RepositorySlug.full(r);

Map<String, User> _cachedUsers = {};
Future<User> _getUser(GitHub github, String username) async {
  if (_cachedUsers.containsKey(username)) return _cachedUsers[username];
  var user = await github.users.getUser(username);
  _cachedUsers[username] = user;
  return user;
}

abstract class Service {
  Workspace workspace;

  Authentication _auth;
  Authentication get auth => _auth;

  GitHub get github;

  Service(this.workspace);

  void loadAuth() {
    var token = workspace.authToken;
    if (token == null) {
      throw ('no token');
    }
    _auth = new Authentication.withToken(token);
  }

  Future<List<Repository>> loadRepos() async {
    var slugs = workspace.repos
        .where(_validRepo)
        .map(_stringToSlug)
        .toList();

    var repoStream = github.repositories.getRepositories(slugs);
    var repoList = await repoStream.toList();
    return repoList;
  }

  Future<PullRequest> loadPullRequests(RepositorySlug slug) async {
    var stream = github.pullRequests.list(slug);
    return await stream.toList();
  }

  Future<PlusOnesRemaining> getPlusOnesRemaining(PullRequest pr) async {
    var taggedUsersVO = new TaggedUsers(pr)..init();
    var tagged = taggedUsersVO.tagged;
    var fyid = taggedUsersVO.fyid;
    var plusOnes = new PlusOnesRemaining(github, pr, tagged, fyid);
    await plusOnes.init();
    return plusOnes;
  }
}

/// calculates the users required to review
/// and how many unreviewed commits there are
class PlusOnesRemaining {
  GitHub github;
  PullRequest _pr;
  List<String> _taggedUsernames;
  List<String> _fyidUsernames;

  List<RepositoryCommit> _unreviewed = [];
  int get unreviewedCommits => _unreviewed.length;
  List<User> remainingUsers = [];
  List<User> taggedUsers = [];
  List<User> fyidUsers = [];

  PlusOnesRemaining(this.github, this._pr, this._taggedUsernames, this._fyidUsernames);

  Future init() async {
    var slug = new RepositorySlug.full(_pr.base.repo.fullName);
    var prNumber = _pr.number;

    var discussionStream = github.issues.listCommentsByIssue(slug, prNumber);
    var comments = await discussionStream.toList();


    List<IssueComment> plusOnes = [];
    for(var comment in comments) {
      if (comment.body.startsWith('+1')) {
        plusOnes.add(comment);
      }
    }

    plusOnes.sort((c1, c2) {
      return c1.createdAt.compareTo(c2.createdAt);
    });

    // make the most recent +1 first
    plusOnes = plusOnes.reversed.toList();

    var commitStream = github.pullRequests.listCommits(slug, prNumber);
    var commits = await commitStream.toList();

    commits.sort((c1, c2) {
      var date1 = c1.commit.author.date;
      var date2 = c2.commit.author.date;
      return date1.compareTo(date2);
    });

    // make the most recent commit first
    commits = commits.reversed.toList();

    if (plusOnes.length == 0) {
      _unreviewed.addAll(commits);
    } else {
      // add only commits AFTER latest +1
      for (var commit in commits) {
        if (commit.commit.author.date.isAfter(plusOnes.first.createdAt)) {
          _unreviewed.add(commit);
        }
      }
    }

    var latestCommit = commits.first;

    var plusOnesSinceLatestCommit = plusOnes.where((comment) {
      return comment.createdAt.isAfter(latestCommit.commit.author.date);
    });

    for (var username in _taggedUsernames) {
      taggedUsers.add(await _getUser(github, username));
    }
    for (var username in _fyidUsernames) {
      fyidUsers.add(await _getUser(github, username));
    }

    remainingUsers = new List.from(taggedUsers);

    // the users that have been tagged, but don't have a +1
    // since the latest commit
    for (var tagged in _taggedUsernames) {
      for (var plusone in plusOnesSinceLatestCommit) {
        if (tagged == plusone.user.login) {
          for (var user in remainingUsers) print(user.login);
          remainingUsers.removeWhere((user) => user.login == plusone.user.login);
          for (var user in remainingUsers) print(user.login);
        }
      }
    }
  }
}

/// calculates the tagged and FYI'd users
/// from a Pull Request
class TaggedUsers {
  PullRequest _pr;
  List<String> tagged = [];
  List<String> fyid = [];
  TaggedUsers(this._pr);
  void init() {
    var lines = _pr.body.split('\n');
    for (var line in lines) {
      var taggedPerson = new RegExp(r"@[A-z-]+");
      var isFyi = line.startsWith('FYI');

      if (line.contains(taggedPerson) &&!isFyi) {
        var taggedPeople = taggedPerson.allMatches(line, 0);
        for (var person in taggedPeople) {
          var username = person.group(0).replaceFirst('@', '');
          tagged.add(username);
        }
      } else if(isFyi) {
        var taggedPeople = taggedPerson.allMatches(line, 0);
        for (var person in taggedPeople) {
          var username = person.group(0).replaceFirst('@', '');
          fyid.add(username);
        }
      }
    }
  }
}
