library githubby.service;

import 'dart:async';

import 'package:github/common.dart';

import 'package:githubby/model.dart';

bool _validRepo(String r) => r != null && r != '';
RepositorySlug _stringToSlug(String r) => new RepositorySlug.full(r);

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
}