import 'package:alterego/models/animator/mediafile_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MediaItem extends StatefulWidget {
  final MediafileInfo mediafile;

  const MediaItem(this.mediafile);

  @override
  _MediaItemState createState() => _MediaItemState();
}

class _MediaItemState extends State<MediaItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
            child: Image.memory(
              widget.mediafile.thumbnail,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.ac_unit),
                onPressed: null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
