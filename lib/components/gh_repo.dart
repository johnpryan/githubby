@HtmlImport('gh_repo.html')
library githubby.gh_repo;
import 'package:githubby/model/repo.dart';
import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer/polymer.dart';

@PolymerRegister('gh-repo')
class GhRepo extends PolymerElement {

  @property
  Repo repo;

  GhRepo.created() : super.created();
}
