@HtmlImport('gh_app.html')
library githubby.gh_app;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

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

  @Property()
  bool displayRepos = true;

  GhApp.created() : super.created();

  @reflectable
  navigateHome([_, __]) {
    set('displayRepos', true);
  }

  @reflectable
  navigateSettings([_, __]) {
    set('displayRepos', false);
  }
}