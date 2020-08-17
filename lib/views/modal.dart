import 'dart:async';

import 'package:bookservice/I18n/i18n.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<T> showImagePickModal<T>(BuildContext context) async {
  return showModalBottomSheet<T>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                FlatButton(
                  child: Text(Localization.of(context).camera),
                  onPressed: () async {
                    await ImagePicker()
                        .getImage(source: ImageSource.camera)
                        .then((file) {
                      if (file != null) {
                        return ImageCropper.cropImage(
                            sourcePath: file.path,
                            maxWidth: 1080,
                            maxHeight: 1920,
                            aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
                            androidUiSettings: AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor: Colors.deepOrange,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                            iosUiSettings: IOSUiSettings(
                              minimumAspectRatio: 1.0,
                            ));
                      }
                      return null;
                    });
                  },
                ),
                Divider(
                  color: Colors.grey,
                ),
                FlatButton(
                  child: Text(Localization.of(context).gallery),
                  onPressed: () async {
                    await ImagePicker()
                        .getImage(source: ImageSource.gallery)
                        .then((file) {
                      if (file != null) {
                        return ImageCropper.cropImage(
                            sourcePath: file.path,
                            maxWidth: 1080,
                            maxHeight: 1920,
                            aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
                            androidUiSettings: AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor: Colors.deepOrange,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                            iosUiSettings: IOSUiSettings(
                              minimumAspectRatio: 1.0,
                            ));
                      }
                      return null;
                    });
                  },
                ),
                Divider(
                  height: 20,
                  thickness: 6,
                ),
                FlatButton(
                  child: Text(Localization.of(context).cancel),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      });
}
