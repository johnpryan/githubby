library load_issues;

import 'dart:io';
import 'package:githubby/model.dart';
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

  // Change to the PR you want to verify
  var slug = new RepositorySlug('Workiva', 'datatables');
  var prNumber = 32;

  try {
    PullRequest pr = await github.pullRequests.list(slug).firstWhere((pr) {
      return pr.number == prNumber;
    });
  } on StateError catch(_) {
    throw('no pr with matching number $prNumber');
  }

  // All commits in the PR
  var commits = await github.pullRequests.listCommits(slug, prNumber).toList();

  // All commits that are github merge
  var mergedCommits = commits.where((commit) {
    var msg = commit.commit.message;
    return msg.contains('Merge pull request #');
  });

  // All commits that are NOT github merges
  Iterable<RepositoryCommit> nonMergedCommits = commits.where((commit) {
    var msg = commit.commit.message;
    return !msg.contains('Merge pull request #');
  });

  // PR numbers for each contributing PR
  Iterable<int> prIds = mergedCommits.map((commit) {
    var message = commit.commit.message;
    var regexp = new RegExp('#([0-9]*)');
    var match = regexp.firstMatch(message);
    var number = match.group(1);
    return int.parse(number);
  });

  // all commits from all contributing PRs
  List<RepositoryCommit> contributingPrCommits = [];

  // populate contributingPrCommits
  for (var id in prIds) {
    print('checking $slug #$id ...');
    var commits = await github.pullRequests.listCommits(slug, id).toList();
    for (var commit in commits) {
      contributingPrCommits.add(commit);
    }
  }

  if (contributingPrCommits.isEmpty) {
    print('No contribuing PRs.  Exiting.');
    return;
  }

  var contributingPrCommitShas = contributingPrCommits.map((commit) {
    return commit.sha;
  });

  var nonContributingCommitShas = nonMergedCommits.map((commit) {
    return commit.sha;
  });

  for (String sha in nonContributingCommitShas) {
    if (!contributingPrCommitShas.contains(sha)) {
      print('${sha.substring(0, 7)}');
    }
  }
}
