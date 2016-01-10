@HtmlImport('gh_toolbar.html')
library githubby.gh_toolbar;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

@PolymerRegister('gh-toolbar')
class GhToolbar extends PolymerElement {
  GhToolbar.created() : super.created();

  @reflectable
  settingsClicked([_, __]) {
    fire('gh-navigate-settings');
  }

  @reflectable
  titleClicked([_, __]) {
    fire('gh-navigate-home');
  }
}