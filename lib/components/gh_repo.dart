@HtmlImport('gh_repo.html')
library githubby.gh_repo;

import 'package:githubby/model.dart';
import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer/polymer.dart';

@PolymerRegister('gh-repo')
class GhRepo extends PolymerElement {

  @property
  DisplayableRepo repo;

  @property
  List<DisplayablePullRequest> get pullRequests => repo.pullRequests;

  GhRepo.created() : super.created();
}
