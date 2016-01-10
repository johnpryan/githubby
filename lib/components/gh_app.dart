@HtmlImport('gh_app.html')
library githubby.gh_app;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:githubby/components/gh_repos.dart';
import 'package:githubby/components/gh_toolbar.dart';

@PolymerRegister('gh-app')
class GhApp extends PolymerElement {
  GhApp.created() : super.created();
}