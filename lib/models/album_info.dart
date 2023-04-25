// To parse this JSON data, do
//
//     final albumInfo = albumInfoFromJson(jsonString);

import 'dart:convert';

AlbumInfo albumInfoFromJson(String str) => AlbumInfo.fromJson(json.decode(str));

String albumInfoToJson(AlbumInfo data) => json.encode(data.toJson());

class AlbumInfo {
  AlbumInfo({
    this.subsonicResponse,
  });

  final SubsonicResponse? subsonicResponse;

  factory AlbumInfo.fromJson(Map<String, dynamic> json) => AlbumInfo(
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
    this.album,
  });

  final String? status;
  final String? version;
  final String? type;
  final String? serverVersion;
  final Album? album;

  factory SubsonicResponse.fromJson(Map<String, dynamic> json) =>
      SubsonicResponse(
        status: json["status"],
        version: json["version"],
        type: json["type"],
        serverVersion: json["serverVersion"],
        album: json["album"] == null ? null : Album.fromJson(json["album"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "version": version,
        "type": type,
        "serverVersion": serverVersion,
        "album": album?.toJson(),
      };
}

class Album {
  Album({
    this.id,
    this.name,
    this.artist,
    this.artistId,
    this.coverArt,
    this.songCount,
    this.duration,
    this.playCount,
    this.played,
    this.created,
    this.starred,
    this.userRating,
    this.year,
    this.song,
  });

  final String? id;
  final String? name;
  final String? artist;
  final String? artistId;
  final String? coverArt;
  final int? songCount;
  final int? duration;
  final int? playCount;
  final DateTime? played;
  final DateTime? created;
  final DateTime? starred;
  final int? userRating;
  final int? year;
  final List<Song>? song;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        id: json["id"],
        name: json["name"],
        artist: json["artist"],
        artistId: json["artistId"],
        coverArt: json["coverArt"],
        songCount: json["songCount"],
        duration: json["duration"],
        playCount: json["playCount"],
        played: json["played"] == null ? null : DateTime.parse(json["played"]),
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        starred:
            json["starred"] == null ? null : DateTime.parse(json["starred"]),
        userRating: json["userRating"],
        year: json["year"],
        song: json["song"] == null
            ? []
            : List<Song>.from(json["song"]!.map((x) => Song.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "artist": artist,
        "artistId": artistId,
        "coverArt": coverArt,
        "songCount": songCount,
        "duration": duration,
        "playCount": playCount,
        "played": played?.toIso8601String(),
        "created": created?.toIso8601String(),
        "starred": starred?.toIso8601String(),
        "userRating": userRating,
        "year": year,
        "song": song == null
            ? []
            : List<dynamic>.from(song!.map((x) => x.toJson())),
      };
}

class Song {
  Song({
    this.id,
    this.parent,
    this.isDir,
    this.title,
    this.album,
    this.artist,
    this.track,
    this.year,
    this.coverArt,
    this.size,
    this.contentType,
    this.suffix,
    this.duration,
    this.bitRate,
    this.path,
    this.playCount,
    this.played,
    this.created,
    this.albumId,
    this.artistId,
    this.type,
    this.userRating,
    this.isVideo,
    this.bookmarkPosition,
    this.starred,
  });

  final String? id;
  final String? parent;
  final bool? isDir;
  final String? title;
  final String? album;
  final String? artist;
  final int? track;
  final int? year;
  final String? coverArt;
  final int? size;
  final String? contentType;
  final String? suffix;
  final int? duration;
  final int? bitRate;
  final String? path;
  final int? playCount;
  final DateTime? played;
  final DateTime? created;
  final String? albumId;
  final String? artistId;
  final String? type;
  final int? userRating;
  final bool? isVideo;
  final int? bookmarkPosition;
  final DateTime? starred;

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        id: json["id"],
        parent: json["parent"],
        isDir: json["isDir"],
        title: json["title"],
        album: json["album"],
        artist: json["artist"],
        track: json["track"],
        year: json["year"],
        coverArt: json["coverArt"],
        size: json["size"],
        contentType: json["contentType"],
        suffix: json["suffix"],
        duration: json["duration"],
        bitRate: json["bitRate"],
        path: json["path"],
        playCount: json["playCount"],
        played: json["played"] == null ? null : DateTime.parse(json["played"]),
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        albumId: json["albumId"],
        artistId: json["artistId"],
        type: json["type"],
        userRating: json["userRating"],
        isVideo: json["isVideo"],
        bookmarkPosition: json["bookmarkPosition"],
        starred:
            json["starred"] == null ? null : DateTime.parse(json["starred"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent": parent,
        "isDir": isDir,
        "title": title,
        "album": album,
        "artist": artist,
        "track": track,
        "year": year,
        "coverArt": coverArt,
        "size": size,
        "contentType": contentType,
        "suffix": suffix,
        "duration": duration,
        "bitRate": bitRate,
        "path": path,
        "playCount": playCount,
        "played": played?.toIso8601String(),
        "created": created?.toIso8601String(),
        "albumId": albumId,
        "artistId": artistId,
        "type": type,
        "userRating": userRating,
        "isVideo": isVideo,
        "bookmarkPosition": bookmarkPosition,
        "starred": starred?.toIso8601String(),
      };
}
