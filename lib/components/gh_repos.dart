@HtmlImport('gh_repos.html')
library githubby.gh_repos;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

@PolymerRegister('gh-repos')
class GhRepos extends PolymerElement {

  GhRepos.created() : super.created();

  ready() {
    print("ready");
  }
}
