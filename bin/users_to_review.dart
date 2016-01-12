library users_to_review;

import 'dart:io';
import 'package:githubby/storage_server.dart';
import 'package:githubby/model.dart';
import 'package:githubby/server_services.dart';
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
  var services = new ServerService(storage.workspace);

  var slug = new RepositorySlug('Workiva', 'datatables');
  var prNumber = 47;

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
  print('latest +1 was at ${latestPlusOne.createdAt} ${latestPlusOne.body} by ${latestPlusOne.user.login}');

  var commitStream = github.pullRequests.listCommits(slug, prNumber);
  var commits = await commitStream.toList();

  List<RepositoryCommit> unreviewed = [];

  for (var commit in commits) {
    if (commit.commit.author.date.isAfter(latestPlusOne.createdAt)) {
      unreviewed.add(commit);
    }
  }

  print('${unreviewed.length} unreviewed commits');
}
