@HtmlImport('gh_repos.html')
library githubby.gh_repos;

import 'package:githubby/components/gh_repo.dart';
import 'package:githubby/model/repo.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

/// [GhRepo]
@PolymerRegister('gh-repos')
class GhRepos extends PolymerElement {

  @Property()
  List<Repo> repos;

  GhRepos.created() : super.created();

  ready() {
    var newRepos = [new Repo()..fullName = 'repo1'];
    set('repos', newRepos);
  }
}
