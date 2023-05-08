// To parse this JSON data, do
//
//     final artistList = artistListFromJson(jsonString);

import 'dart:convert';

ArtistList artistListFromJson(String str) =>
    ArtistList.fromJson(json.decode(str));

String artistListToJson(ArtistList data) => json.encode(data.toJson());

class ArtistList {
  final SubsonicResponse? subsonicResponse;

  ArtistList({
    this.subsonicResponse,
  });

  factory ArtistList.fromJson(Map<String, dynamic> json) => ArtistList(
        subsonicResponse: json["subsonic-response"] == null
            ? null
            : SubsonicResponse.fromJson(json["subsonic-response"]),
      );

  Map<String, dynamic> toJson() => {
        "subsonic-response": subsonicResponse?.toJson(),
      };
}

class SubsonicResponse {
  final String? status;
  final String? version;
  final String? type;
  final String? serverVersion;
  final Artists? artists;

  SubsonicResponse({
    this.status,
    this.version,
    this.type,
    this.serverVersion,
    this.artists,
  });

  factory SubsonicResponse.fromJson(Map<String, dynamic> json) =>
      SubsonicResponse(
        status: json["status"],
        version: json["version"],
        type: json["type"],
        serverVersion: json["serverVersion"],
        artists:
            json["artists"] == null ? null : Artists.fromJson(json["artists"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "version": version,
        "type": type,
        "serverVersion": serverVersion,
        "artists": artists?.toJson(),
      };
}

class Artists {
  final List<Index>? index;
  final int? lastModified;
  final String? ignoredArticles;

  Artists({
    this.index,
    this.lastModified,
    this.ignoredArticles,
  });

  factory Artists.fromJson(Map<String, dynamic> json) => Artists(
        index: json["index"] == null
            ? []
            : List<Index>.from(json["index"]!.map((x) => Index.fromJson(x))),
        lastModified: json["lastModified"],
        ignoredArticles: json["ignoredArticles"],
      );

  Map<String, dynamic> toJson() => {
        "index": index == null
            ? []
            : List<dynamic>.from(index!.map((x) => x.toJson())),
        "lastModified": lastModified,
        "ignoredArticles": ignoredArticles,
      };
}

class Index {
  final String? name;
  final List<Artist>? artist;

  Index({
    this.name,
    this.artist,
  });

  factory Index.fromJson(Map<String, dynamic> json) => Index(
        name: json["name"],
        artist: json["artist"] == null
            ? []
            : List<Artist>.from(json["artist"]!.map((x) => Artist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "artist": artist == null
            ? []
            : List<dynamic>.from(artist!.map((x) => x.toJson())),
      };
}

class Artist {
  final String? id;
  final String? name;
  final int? albumCount;
  final int? userRating;
  final String? coverArt;
  final String? artistImageUrl;
  final DateTime? starred;

  Artist({
    this.id,
    this.name,
    this.albumCount,
    this.userRating,
    this.coverArt,
    this.artistImageUrl,
    this.starred,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        id: json["id"],
        name: json["name"],
        albumCount: json["albumCount"],
        userRating: json["userRating"],
        coverArt: json["coverArt"],
        artistImageUrl: json["artistImageUrl"],
        starred:
            json["starred"] == null ? null : DateTime.parse(json["starred"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "albumCount": albumCount,
        "userRating": userRating,
        "coverArt": coverArt,
        "artistImageUrl": artistImageUrl,
        "starred": starred?.toIso8601String(),
      };
}
