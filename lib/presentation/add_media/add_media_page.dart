import 'package:alterego/blocs/add_media/add_media_cubit.dart';
import 'package:alterego/net/interfaces/IImageApiClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddMediaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddMediaCubit>(
      create: (context) => AddMediaCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add new {}", style: TextStyle(color: Colors.black)),
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocConsumer<AddMediaCubit, AddMediaState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("From camera"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final _picker = ImagePicker();
                        PickedFile media =
                            await _picker.getImage(source: ImageSource.gallery);

                        if (media != null)
                          context.bloc<AddMediaCubit>().selectMedia(media);
                      },
                      child: Text("From gallery"),
                    ),
                  ],
                ),
                if (state is AddMediaSelected)
                  FlatButton(
                    onPressed: () {
                      context
                          .bloc<AddMediaCubit>()
                          .createAndSend<IImageApiClient>(
                            "TEST",
                            context.repository<IImageApiClient>(),
                          );
                    },
                    child: Text("Send"),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
