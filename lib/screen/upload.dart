import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

import '../storage/storage.dart';
import '../store/store.dart';

class UploadPage extends StatefulWidget {
  UploadPage();

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];

  FirebaseStorage storage = Storage.instance.firebaseStorage;

  Future<void> _uploadFile(file) async {
    String fileName = file.path.substring(file.path.lastIndexOf('/') + 1);
    String fileType = file.path.substring(file.path.lastIndexOf('.') + 1);
    final StorageReference ref = storage.ref().child('source').child(fileName);
    
    final StorageUploadTask uploadTask = ref.putFile(file, StorageMetadata(
        contentType: 'image/' + fileType,
      ),
    )..events.listen((event){
      if(event.type == StorageTaskEventType.success) {
        event.snapshot.ref.getDownloadURL().then((url){
          Store.instance.sourceRef.document(Uuid().v4()).setData({
            'url': url,
          });
        });
      }
    });

    setState(() {
      _tasks.add(uploadTask);
    });
  }

  Future<void> _deleteFile(file) async {
    return storage.ref().child('source').child(file).delete();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    _tasks.forEach((StorageUploadTask task) {
      final Widget tile = UploadTaskListTile(
        task: task,
        onDismissed: () => setState(() => _tasks.remove(task)),
      );
      children.add(tile);
    });
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Upload')
      ),
      body: ListView(
        children: children,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return ImagePicker.pickImage(source: ImageSource.gallery).then((file){
            if(file != null){
              _uploadFile(file);
            }
          });
        },
        child: const Icon(Icons.file_upload),
      ),
    );
  }
}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed})
      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;

  String get status {
    String result;
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
    return result;
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  @override
  Widget build(BuildContext context) {
    return buildTask();
  }

  Widget buildTask() => StreamBuilder<StorageTaskEvent>(
    stream: task.events,
    builder: (BuildContext context, AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
      Widget subtitle;
      if (asyncSnapshot.hasData) {
        final StorageTaskEvent event = asyncSnapshot.data;
        final StorageTaskSnapshot snapshot = event.snapshot;
        subtitle = Text('$status: ${_bytesTransferred(snapshot)} bytes sent');
      } else { 
        subtitle = const Text('Starting...');
      }
      return Dismissible(
        key: Key(task.hashCode.toString()),
        onDismissed: (_) => onDismissed(),
        child: ListTile(
          title: Text('Upload Task #${task.hashCode}'),
          subtitle: subtitle,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Offstage(
                offstage: !task.isInProgress,
                child: IconButton(
                  icon: const Icon(Icons.pause),
                  onPressed: () => task.pause(),
                ),
              ),
              Offstage(
                offstage: !task.isPaused,
                child: IconButton(
                  icon: const Icon(Icons.file_upload),
                  onPressed: () => task.resume(),
                ),
              ),
              Offstage(
                offstage: task.isComplete,
                child: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () => task.cancel(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
