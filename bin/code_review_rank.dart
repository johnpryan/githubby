library load_issues;

import 'dart:io';
import 'package:intl/intl.dart';
import 'package:args/args.dart';
import 'package:githubby/model.dart';
import 'package:githubby/storage_server.dart';
import 'package:github/server.dart';

final DateFormat dateFormat = new DateFormat('yyyy-MM-dd hh:mm:ss a');

main(List<String> args) async {
  var parser = new ArgParser();
  var results = parser.parse(args);
  if (results.rest.length < 2) {
    print('''Usage:
    dart code_review_rank.dart [repository slug] [pr limit]''');
    return;
  }
  var slugString = results.rest.first;
  var limit = int.parse(results.rest.elementAt(1));

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

  // Change to the PR you want to verify
  var slug = new RepositorySlug.full(slugString);
  var prStream = github.pullRequests.list(slug, pages: 5, state: "closed");
  var mergedStream = prStream.where((PullRequest pr) {
    return pr.mergedAt != null;
  });
  var limitStream = mergedStream.take(limit);
  print('PR NUMBER, URL, CREATED, MERGED');
  await for (PullRequest pr in limitStream) {
    var created = dateFormat.format(pr.createdAt);
    var merged = dateFormat.format(pr.mergedAt);
    print('${pr.number}, ${pr.htmlUrl}, ${created}, ${merged}');
  }
}
