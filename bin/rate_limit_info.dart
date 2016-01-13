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

  var slug = new RepositorySlug('Workiva', 'datatables');
  await github.pullRequests.list(slug, pages: 1).first;

  print('rate limit is at ${github.rateLimitRemaining}');
  print('rate limit resetting in ${github.rateLimitReset.difference(new DateTime.now())}');
}
