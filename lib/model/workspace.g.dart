// GENERATED CODE - DO NOT MODIFY BY HAND
// 2016-01-13T07:03:51.181Z

part of githubby.workspace;

// **************************************************************************
// Generator: JsonSerializableGenerator
// Target: class Workspace
// **************************************************************************

Workspace _$WorkspaceFromJson(Map json) => new Workspace(json['authToken'],
    json['repos']?.map((v0) => v0)?.toList(), json['showBadges']);

abstract class _$WorkspaceSerializerMixin {
  String get authToken;
  List get repos;
  bool get showBadges;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'authToken': authToken,
        'repos': repos,
        'showBadges': showBadges
      };
}
