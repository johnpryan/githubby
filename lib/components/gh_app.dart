@HtmlImport('gh_app.html')
library githubby.gh_app;

import 'dart:async';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:githubby/context.dart';
import 'package:githubby/components/gh_container.dart';
import 'package:githubby/components/gh_repos.dart';
import 'package:githubby/components/gh_toolbar.dart';
import 'package:githubby/components/gh_settings.dart';

/// silence analyzer
/// [GhRepos]
/// [GhToolbar]
/// [GhSettings]
/// [GhContainer]
@PolymerRegister('gh-app')
class GhApp extends PolymerElement {

  GhRepos _reposElem;
  GhSettings _settingsElem;

  @Property()
  bool displayRepos = true;

  GhApp.created() : super.created();

  attached() {
    _reposElem = $$('#gh-repos');
    _settingsElem = $$('#gh-settings');
    _assignContexts();
  }

  Future _assignContexts() async {
    var context = new Context();
    await context.initialize();
    _reposElem.context = context;
    _settingsElem.context = context;
  }

  @reflectable
  navigateHome([_, __]) {
    print('navigate Home');
    set('displayRepos', true);
    _reposElem.reload();
  }

  @reflectable
  navigateSettings([_, __]) {
    set('displayRepos', false);
    _settingsElem.render();
  }
}