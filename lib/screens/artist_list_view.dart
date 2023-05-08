import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pipe/models/artist_list.dart';
import 'package:pipe/models/server.dart';
import 'package:http/http.dart' as http;
import 'package:pipe/utlities/cover_art_url.dart';

class ArtistListView extends StatelessWidget {
  const ArtistListView({Key? key, required this.server}) : super(key: key);
  final Server server;

  Future<ArtistList> getArtistList() async {
    final queryParameters = {
      'u': server.username,
      'p': server.password,
      'v': server.version,
      'c': server.appName,
      'f': server.responseFormat,
    };
    final uri = Uri.http(server.host, '/rest/getArtists', queryParameters);
    final res =
        await http.get(uri, headers: {"Content-Type": "application/json"});
    return artistListFromJson(utf8.decode(res.bodyBytes));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ArtistList>(
        future: getArtistList(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List artistListWithcategory =
              snapshot.data?.subsonicResponse?.artists?.index ?? [];
          print(artistListWithcategory);
          final List<Artist> artistList = [];
          for (Index index in artistListWithcategory) {
            List<Artist> artists = index.artist ?? [];
            artistList.addAll(artists);
          }
          return ListView(
            children: [
              for (Artist artist in artistList)
                ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: getAlbumCoverUrl(artist.coverArt!, 100, server),
                    height: 45,
                    width: 45,
                  ),
                  title: Text(artist.name ?? ''),
                  subtitle: Text(artist.albumCount.toString()),
                )
            ],
          );
        },
      ),
    );
  }
}
