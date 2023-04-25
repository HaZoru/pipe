// To parse this JSON data, do
//
//     final albumCover = albumCoverFromJson(jsonString);

import 'dart:convert';

AlbumCover albumCoverFromJson(String str) =>
    AlbumCover.fromJson(json.decode(str));

String albumCoverToJson(AlbumCover data) => json.encode(data.toJson());

class AlbumCover {
  AlbumCover({
    this.subsonicResponse,
  });

  final SubsonicResponse? subsonicResponse;

  factory AlbumCover.fromJson(Map<String, dynamic> json) => AlbumCover(
        subsonicResponse: json["subsonic-response"] == null
            ? null
            : SubsonicResponse.fromJson(json["subsonic-response"]),
      );

  Map<String, dynamic> toJson() => {
        "subsonic-response": subsonicResponse?.toJson(),
      };
}

class SubsonicResponse {
  SubsonicResponse({
    this.status,
    this.version,
    this.type,
    this.serverVersion,
    this.albumInfo,
  });

  final String? status;
  final String? version;
  final String? type;
  final String? serverVersion;
  final AlbumInfo? albumInfo;

  factory SubsonicResponse.fromJson(Map<String, dynamic> json) =>
      SubsonicResponse(
        status: json["status"],
        version: json["version"],
        type: json["type"],
        serverVersion: json["serverVersion"],
        albumInfo: json["albumInfo"] == null
            ? null
            : AlbumInfo.fromJson(json["albumInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "version": version,
        "type": type,
        "serverVersion": serverVersion,
        "albumInfo": albumInfo?.toJson(),
      };
}

class AlbumInfo {
  AlbumInfo({
    this.lastFmUrl,
    this.smallImageUrl,
    this.mediumImageUrl,
    this.largeImageUrl,
  });

  final String? lastFmUrl;
  final String? smallImageUrl;
  final String? mediumImageUrl;
  final String? largeImageUrl;

  factory AlbumInfo.fromJson(Map<String, dynamic> json) => AlbumInfo(
        lastFmUrl: json["lastFmUrl"],
        smallImageUrl: json["smallImageUrl"],
        mediumImageUrl: json["mediumImageUrl"],
        largeImageUrl: json["largeImageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "lastFmUrl": lastFmUrl,
        "smallImageUrl": smallImageUrl,
        "mediumImageUrl": mediumImageUrl,
        "largeImageUrl": largeImageUrl,
      };
}
