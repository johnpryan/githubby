@HtmlImport('gh_pull_request.html')
library githubby.gh_pull_request;

import 'package:githubby/displayable.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

@PolymerRegister('gh-pull-request')
class GhPullRequest extends PolymerElement {

  @Property()
  DisplayablePullRequest pullRequest;

  @property get hide => pullRequest?.hide ?? false;

  GhPullRequest.created() : super.created();
}