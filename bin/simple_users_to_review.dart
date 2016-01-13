library simple_users_to_review;

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

  // Get a PR to check
  var auth = new Authentication.withToken(storage.workspace.authToken);
  var github = createGitHubClient(auth: auth);

  var slug = new RepositorySlug('Workiva', 'datatables');
  var prNumber = 60;
  var pr = await github.pullRequests.get(slug,prNumber);

  // init the services
  var services = new ServerService(storage.workspace);
  await services.loadAuth();

  // get and print the users that need to review the PR
  var prs = await services.getPlusOnesRemaining(pr);
  var users = prs.remainingUsers;

  if (users.isEmpty) {
    print('all tagged users have reviewed');
    return;
  }

  stdout.write('${prs.unreviewedCommits} commits need review by');
  for (var user in users) {
    stdout.write(' ' + user.login);
  }
  stdout.write('\n');
}