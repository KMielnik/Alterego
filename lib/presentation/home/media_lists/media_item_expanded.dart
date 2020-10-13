import 'dart:io';
import 'dart:typed_data';

import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:alterego/net/interfaces/IMediaApiClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MediaItemExpanded extends StatefulWidget {
  final MediafileInfo mediafile;

  MediaItemExpanded(this.mediafile);

  @override
  _MediaItemExpandedState createState() => _MediaItemExpandedState();
}

class _MediaItemExpandedState extends State<MediaItemExpanded> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          brightness: Brightness.dark,
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Hero(
                tag: "${widget.mediafile.filename}_thumbnail",
                child: FutureBuilder<Uint8List>(
                  initialData: widget.mediafile.thumbnail,
                  future: context
                      .repository<IImageApiClient>()
                      .downloadSpecifiedToTemp(
                          filename: widget.mediafile.filename)
                      .then((value) => File(value).readAsBytes())
                      .then((value) => null),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return AnimatedSwitcher(
                        switchInCurve: Curves.fastOutSlowIn,
                        switchOutCurve: Curves.fastOutSlowIn,
                        duration: Duration(milliseconds: 500),
                        child: Image.memory(
                          snapshot.data,
                          key: Key((snapshot.data == widget.mediafile.thumbnail)
                              .toString()),
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                      );
                    return SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Center(
                        child: Text("Error retrieving data."),
                      ),
                    );
                  },
                ),
              ),
              Text(widget.mediafile.originalFilename),
            ],
          ),
        ));
  }
}
