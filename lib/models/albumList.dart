// To parse this JSON data, do
//
//     final albumList = albumListFromJson(jsonString);

import 'dart:convert';

AlbumList albumListFromJson(String str) => AlbumList.fromJson(json.decode(str));

String albumListToJson(AlbumList data) => json.encode(data.toJson());

class AlbumList {
  AlbumList({
    this.subsonicResponse,
  });

  final SubsonicResponse? subsonicResponse;

  factory AlbumList.fromJson(Map<String, dynamic> json) => AlbumList(
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
    this.albumList,
  });

  final String? status;
  final String? version;
  final String? type;
  final String? serverVersion;
  final AlbumListClass? albumList;

  factory SubsonicResponse.fromJson(Map<String, dynamic> json) =>
      SubsonicResponse(
        status: json["status"],
        version: json["version"],
        type: json["type"],
        serverVersion: json["serverVersion"],
        albumList: json["albumList"] == null
            ? null
            : AlbumListClass.fromJson(json["albumList"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "version": version,
        "type": type,
        "serverVersion": serverVersion,
        "albumList": albumList?.toJson(),
      };
}

class AlbumListClass {
  AlbumListClass({
    this.album,
  });

  final List<AlbumMetaData>? album;

  factory AlbumListClass.fromJson(Map<String, dynamic> json) => AlbumListClass(
        album: json["album"] == null
            ? []
            : List<AlbumMetaData>.from(
                json["album"]!.map((x) => AlbumMetaData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "album": album == null
            ? []
            : List<dynamic>.from(album!.map((x) => x.toJson())),
      };
}

class AlbumMetaData {
  AlbumMetaData({
    this.id,
    this.parent,
    this.isDir,
    this.title,
    this.name,
    this.album,
    this.artist,
    this.year,
    this.genre,
    this.coverArt,
    this.starred,
    this.duration,
    this.playCount,
    this.played,
    this.created,
    this.artistId,
    this.songCount,
    this.isVideo,
    this.userRating,
  });

  final String? id;
  final String? parent;
  final bool? isDir;
  final String? title;
  final String? name;
  final String? album;
  final String? artist;
  final int? year;
  final String? genre;
  final String? coverArt;
  final DateTime? starred;
  final int? duration;
  final int? playCount;
  final DateTime? played;
  final DateTime? created;
  final String? artistId;
  final int? songCount;
  final bool? isVideo;
  final int? userRating;

  factory AlbumMetaData.fromJson(Map<String, dynamic> json) => AlbumMetaData(
        id: json["id"],
        parent: json["parent"],
        isDir: json["isDir"],
        title: json["title"],
        name: json["name"],
        album: json["album"],
        artist: json["artist"],
        year: json["year"],
        genre: json["genre"],
        coverArt: json["coverArt"],
        starred:
            json["starred"] == null ? null : DateTime.parse(json["starred"]),
        duration: json["duration"],
        playCount: json["playCount"],
        played: json["played"] == null ? null : DateTime.parse(json["played"]),
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        artistId: json["artistId"],
        songCount: json["songCount"],
        isVideo: json["isVideo"],
        userRating: json["userRating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent": parent,
        "isDir": isDir,
        "title": title,
        "name": name,
        "album": album,
        "artist": artist,
        "year": year,
        "genre": genre,
        "coverArt": coverArt,
        "starred": starred?.toIso8601String(),
        "duration": duration,
        "playCount": playCount,
        "played": played?.toIso8601String(),
        "created": created?.toIso8601String(),
        "artistId": artistId,
        "songCount": songCount,
        "isVideo": isVideo,
        "userRating": userRating,
      };
}
