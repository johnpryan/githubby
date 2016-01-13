@HtmlImport('gh_pull_request.html')
library githubby.gh_pull_request;

import 'package:githubby/displayable.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;
import 'package:polymer_time_ago/polymer_time_ago.dart';

/// [TimeAgo]
@PolymerRegister('gh-pull-request')
class GhPullRequest extends PolymerElement {

  @Property()
  DisplayablePullRequest pullRequest;

  @property
  get hide => pullRequest?.hide ?? false;

  @property
  bool showBadges;

  GhPullRequest.created() : super.created();
}