@HtmlImport('gh_toolbar.html')
library githubby.gh_toolbar;

import 'package:githubby/components/gh_container.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

/// [GhContainer]
@PolymerRegister('gh-toolbar')
class GhToolbar extends PolymerElement {
  GhToolbar.created() : super.created();

  @reflectable
  titleClicked([_, __]) {
    fire('gh-navigate-home');
  }
}