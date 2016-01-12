library users_to_review;

import 'dart:io';
import 'package:githubby/storage_server.dart';
import 'package:githubby/model.dart';
//import 'package:githubby/server_services.dart';
import 'package:github/server.dart';

main() async {
  var storage = new StorageServer();
  await storage.load();

  if (storage.workspace == null) {
    print('no config file found.  Enter your github auth token:');
    var authToken = stdin.readLineSync();
    storage.workspace = new Workspace(authToken, []);
    await storage.save();
  }
  var auth = new Authentication.withToken(storage.workspace.authToken);
  var github = createGitHubClient(auth: auth);
//  var services = new ServerService(storage.workspace);

  var slug = new RepositorySlug('Workiva', 'linking-demo');
  var prNumber = 72;

  var pr = await github.pullRequests.get(slug, prNumber);
  var lines = pr.body.split('\n');
  List<String> taggedUsernames = [];
  List<String> fyidUsernames = [];
  for (var line in lines) {
    var taggedPerson = new RegExp(r"@[A-z-]+");
    var isFyi = line.startsWith('FYI');
    if (line.contains(taggedPerson) &&!isFyi) {
      var taggedPeople = taggedPerson.allMatches(line, 1);
      for (var person in taggedPeople) {
        var username = person.group(0).replaceFirst('@', '');
        taggedUsernames.add(username);
        print('${username} was tagged');
      }
    } else if(isFyi) {
      var taggedPeople = taggedPerson.allMatches(line, 1);
      for (var person in taggedPeople) {
        var username = person.group(0).replaceFirst('@', '');
        fyidUsernames.add(username);
        print('${username} was FYId');
      }
    }
  }

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

  var latestPlusOne = plusOnes.first;

  var commitStream = github.pullRequests.listCommits(slug, prNumber);
  var commits = await commitStream.toList();

  commits.sort((c1, c2) {
    var date1 = c1.commit.author.date;
    var date2 = c2.commit.author.date;
    return date1.compareTo(date2);
  });

  List<RepositoryCommit> unreviewed = [];

  for (var commit in commits) {
    if (commit.commit.author.date.isAfter(latestPlusOne.createdAt)) {
      unreviewed.add(commit);
    }
  }

  var latestCommit = commits.first;

  var plusOnesSinceLatestCommit = plusOnes.where((comment) {
    return comment.createdAt.isAfter(latestCommit.commit.author.date);
  });

  // the users that have been tagged, but don't have a +1
  // since the latest commit
  var usersToReview = taggedUsernames.where((username) {
    for(var comment in plusOnesSinceLatestCommit) {
      if (username = comment.user.login) {
        return true;
      }
    }
    return false;
  });

  // print remaining reviewers
  if(!unreviewed.isEmpty) {
    print('${unreviewed.length} unreviewed commits');
  } else {
    if (usersToReview.isEmpty) {
      print('all tagged people have reviewed this PR');
    } else {
      print('all commits reviewed.  Remaining reviewers:');
      for (var user in usersToReview) {
        print(user);
      }
    }
  }
}
