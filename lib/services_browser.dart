import 'services.dart';

import 'package:github/browser.dart' hide Service;

import 'package:githubby/services.dart';
import 'package:githubby/model.dart';

class BrowserService extends Service {
  GitHub _github;
  GitHub get github => _github;

  BrowserService(Workspace workspace) : super(workspace) {
    _github = createGitHubClient(auth: auth);
  }
}