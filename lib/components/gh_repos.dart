@HtmlImport('gh_repos.html')
library githubby.gh_repos;

import 'dart:async';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:githubby/services_browser.dart';
import 'package:githubby/storage_browser.dart';
import 'package:githubby/components/gh_repo.dart';
import 'package:githubby/model/repo.dart';

/// [GhRepo]
@PolymerRegister('gh-repos')
class GhRepos extends PolymerElement {

  @Property()
  bool hasStorage = true;

  @Property()
  List<Repo> repos;

  GhRepos.created() : super.created();

  ready() {
    _loadRepos();
  }

  Future _loadRepos() async {
    var storage = new StorageBrowser();

    await storage.load();

    if (!storage.hasData) {
      _displayStorageError();
      return;
    }

    var service = new BrowserService(storage.workspace);

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
