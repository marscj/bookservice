import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'storage.dart';
import '../l10n/applocalization.dart';

StorageUploadTask uploadFile(StorageReference ref, File file) {
  String fileName = file.path.substring(file.path.lastIndexOf('/') + 1);
  String fileType = file.path.substring(file.path.lastIndexOf('.') + 1);
  StorageMetadata meta = new StorageMetadata(
    contentType: 'image/' + fileType
  );
  return ref.child(fileName).putFile(file, meta);
}

StorageUploadTask uploadNameFile(StorageReference ref, File file, name) {
  String fileType = file.path.substring(file.path.lastIndexOf('.') + 1);
  StorageMetadata meta = new StorageMetadata(
    contentType: 'image/' + fileType
  );
  return ref.child(name + '.' + file.path.substring(file.path.lastIndexOf('.') + 1)).putFile(file, meta);
}

class UploadFile extends StatefulWidget {

  UploadFile({
    Key key,
    this.size = const Size(52.0, 52.0),
    @required this.onChange
  }) : super(key: key);

  final ValueChanged onChange;
  final Size size;

  @override
  State<UploadFile> createState() => new UploadFileState();
}

class UploadFileState extends State<UploadFile> {
  
  StorageUploadTask task;
  File file;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (task != null && task.isInProgress) {
      task.cancel();
    }
    task = null;
    file = null;
    super.dispose();
  }

  Future<void> _deleteFile(File file) {
    String fileName = file.path.substring(file.path.lastIndexOf('/') + 1);
    return Storage.instance.bookingRef.child(fileName).delete();
  }
 
  String get status {

    String result;

    if (task != null) {
      if (task.isComplete) {
        if (task.isSuccessful) {
          result = 'Complete';
        } else if (task.isCanceled) {
          result = 'Canceled';
        } else {
          result = 'Failed ERROR: ${task.lastSnapshot.error}';
        }
      } else if (task.isInProgress) {
        result = 'Uploading';
      } else if (task.isPaused) {
        result = 'Paused';
      }
    }
    return result ?? '';
  }

  double _bytesTransferred(StorageTaskSnapshot snapshot) {
    if (snapshot != null) {
      if (task != null && task.isSuccessful) {
        return 52.0;
      }
      return snapshot.bytesTransferred/snapshot.totalByteCount * widget.size.height;
    }
    return 0.0; 
  }

  Future pickImage() async {
    return showDialog<ImageSource>(
      context: context,
      builder: (_){
        return new SimpleDialog(
          children: [
            new ListTile(
              title: new Text(AppLocalizations.of(context).camera),
              trailing: new Icon(Icons.camera),
              onTap: () {
                Navigator.of(context).pop(ImageSource.camera);
              },
            ),
            new Divider(),
            new ListTile(
              title: new Text(AppLocalizations.of(context).gallery),
              trailing: new Icon(Icons.photo_library),
              onTap: () {
                Navigator.of(context).pop(ImageSource.gallery);
              },
            )
          ]
        );
      }
    ).then((onValue){
      if (onValue != null) {
        return ImagePicker.pickImage(source: onValue, maxWidth: 480.0, maxHeight: 270.0);
      }
    }).then((onValue){
      if (onValue != null) {
        setState(() {
          file = onValue;
          task = uploadFile(Storage.instance.bookingRef, onValue)..events.listen(listen);
        });
      }
    });
  }

  void listen(onData){
    if(onData != null) {
      if (onData.type == StorageTaskEventType.success) {
        task.lastSnapshot.ref.getDownloadURL().then((onValue){
          widget.onChange(onValue);
        });
      } else if (onData.type == StorageTaskEventType.failure) {
        Fluttertoast.showToast(msg: 'Upload failure');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task?.events,
      builder: (BuildContext context, AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        if (asyncSnapshot.hasError) {
          print(asyncSnapshot.error.toString());
        }
        return new Padding(
          padding: new EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            children: file == null ? <Widget>[
              new Text(AppLocalizations.of(context).upload),
              new SizedBox(width: 10.0),
              new IconButton(
                icon: new Icon(Icons.image, size: widget.size.height),
                onPressed: () {
                  pickImage();
                },
              )
            ] : <Widget> [
              new SizedBox.fromSize(
                size: widget.size,
                child: new Padding(
                  padding: EdgeInsets.zero,
                  child: new Stack( 
                    fit: StackFit.expand, 
                    children: <Widget>[
                      new Image.file(file, fit: BoxFit.cover),
                      new Positioned.fill(
                        top: _bytesTransferred(asyncSnapshot?.data?.snapshot),
                        child: new Container(
                          color: Colors.black38,
                        )
                      ),
                    ],
                  )
                )
              ),
              new Offstage(
                offstage: !(task.isComplete && task.isSuccessful) && task.isComplete,
                child: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    if (task.isInProgress) {
                      task.cancel();
                      setState(() {
                        task = null;
                        file = null;
                      });
                    } else {
                      if (task.isSuccessful) {
                        _deleteFile(file).then((onValue){
                          setState(() {
                            task = null;
                            file = null;
                          });
                        });
                      }
                    }
                  } 
                )
              )
            ],
          )
        );
      },
    );
  }
}