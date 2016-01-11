// GENERATED CODE - DO NOT MODIFY BY HAND
// 2016-01-11T01:07:18.719Z

part of githubby.workspace;

// **************************************************************************
// Generator: JsonSerializableGenerator
// Target: class Workspace
// **************************************************************************

Workspace _$WorkspaceFromJson(Map json) =>
    new Workspace(json['authToken'], json['repos']?.map((v0) => v0)?.toList());

abstract class _$WorkspaceSerializerMixin {
  String get authToken;
  List get repos;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'authToken': authToken, 'repos': repos};
}
