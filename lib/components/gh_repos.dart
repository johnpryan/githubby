@HtmlImport('gh_repos.html')
library githubby.gh_repos;

import 'dart:async';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:githubby/context.dart';
import 'package:githubby/components/gh_repo.dart';
import 'package:githubby/model/repo.dart';

/// [GhRepo]
@PolymerRegister('gh-repos')
class GhRepos extends PolymerElement {

  Context _context;

  @Property()
  bool hasStorage = true;

  @Property()
  List<Repo> repos;

  GhRepos.created() : super.created();

  void set context(Context c) {
    _context = c;
    _loadRepos();
  }

  reload() {
    set('repos', []);
    _loadRepos();
  }

  Future _loadRepos() async {
    var storage = _context.storage;
    if (!storage.hasData) {
      _displayStorageError();
      return;
    }

    var service = _context.service;
    var repos = await service.loadRepos();

    var renderableRepos = repos.map((repository) {
      return new Repo(repository);
    }).toList();

    set('repos', renderableRepos);
  }

  _displayStorageError() {
    hasStorage = false;
  }
}
