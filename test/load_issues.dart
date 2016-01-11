library load_issues;

import 'dart:io';
import 'package:githubby/model/workspace.dart';
import 'package:githubby/storage_server.dart';
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

  var pullRequestStream = github.pullRequests.list(new RepositorySlug('dart-lang', 'sdk'));
  var pullRequestList = await pullRequestStream.toList();
  print(pullRequestList);

  var issuesStream = github.issues.listByRepo(new RepositorySlug('dart-lang', 'sdk'));
  var issuesList = await issuesStream.toList();
  for (var issue in issuesList) {
    print(issue.title);
  }

  print('rate limit is at ${github.rateLimitRemaining}');
  print('rate limit resetting in ${github.rateLimitReset.difference(new DateTime.now())}');
}
