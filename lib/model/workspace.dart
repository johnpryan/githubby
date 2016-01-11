library githubby.workspace;

import 'package:source_gen/generators/json_serializable.dart';

part 'workspace.g.dart';

/// Defines all of the content for the app;
/// repositories, auth, etc
///
/// this should/could use source_gen eventually
@JsonSerializable()
class Workspace extends Object with _$WorkspaceSerializerMixin {

  String authToken;
  List<String> repos;

  Workspace(this.authToken, this.repos);

  factory Workspace.fromJson(json) => _$WorkspaceFromJson(json);
}
