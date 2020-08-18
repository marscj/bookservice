import 'dart:async';

import 'package:bookservice/I18n/i18n.dart';
import 'package:bookservice/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<T> showImagePickModal<T>(BuildContext context,
    {int maxWidth = 1080,
    int maxHeight = 1920,
    CropAspectRatio aspectRatio =
        const CropAspectRatio(ratioX: 16, ratioY: 9)}) async {
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
                            maxWidth: maxWidth,
                            maxHeight: maxHeight,
                            aspectRatio: aspectRatio,
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
                    }).then((value) => Navigator.of(context).pop(value));
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
                            maxWidth: maxWidth,
                            maxHeight: maxHeight,
                            aspectRatio: aspectRatio,
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
                    }).then((value) => Navigator.of(context).pop(value));
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

Future<T> showAddressPickModal<T>(BuildContext context) async {
  return showModalBottomSheet<T>(
      context: context,
      builder: (BuildContext context) {
        return AddressListPage(
          pick: true,
        );
      });
}

Future<T> showCommentModal<T>(BuildContext context, objectid, contenttype,
    {reply}) async {
  return showModalBottomSheet<T>(
      context: context,
      builder: (BuildContext context) {
        return OrderCommentPostPage(
            objectid: objectid, contenttype: contenttype, reply: reply);
      });
}

Future<T> showImagePostModal<T>(BuildContext context, postId) async {
  return showModalBottomSheet<T>(
      context: context,
      builder: (BuildContext context) {
        return AdditionPostPage(postId: postId);
      });
}
