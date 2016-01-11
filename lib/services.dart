library githubby.service;

import 'dart:async';

import 'package:github/common.dart';

import 'package:githubby/model.dart';

abstract class Service {
  Workspace workspace;

  Authentication _auth;
  Authentication get auth => _auth;

  GitHub get github;

  Service(this.workspace) {
    var token = workspace.authToken;
    if (token == null) {
      throw ('no token');
    }
    _auth = new Authentication.withToken(token);
  }

  Future<List<Repository>> loadRepos() async {
    var slugs = [new RepositorySlug('dart-lang', 'sdk')];
    var repos = github.repositories.getRepositories(slugs);
    return await repos.toList();
  }
}