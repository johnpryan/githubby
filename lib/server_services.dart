import 'services.dart';

import 'package:github/server.dart' hide Service;
import 'package:githubby/model.dart';

class ServerService extends Service {
  GitHub _github;
  GitHub get github => _github;

  ServerService(Workspace workspace) : super(workspace);

  void loadAuth() {
    super.loadAuth();
    _github = createGitHubClient(auth: auth);
  }
}