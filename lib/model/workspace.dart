library githubby.workspace;

/// Defines all of the content for the app;
/// repositories, auth, etc
///
/// this should/could use source_gen eventually
class Workspace {
  String authToken;

  Workspace(this.authToken);

  factory Workspace.fromJson(Map<String, Object> json) {
    return new Workspace(json['authToken']);
  }

  Map toJson() {
    return {
      'authToken': authToken
    };
  }
}
