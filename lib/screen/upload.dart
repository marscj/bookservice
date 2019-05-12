import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../l10n/applocalization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

import '../storage/storage.dart';
import '../store/store.dart';

final List<String> userType = [
    'unknow',
    'welcome',
    'banner'
];

List<StorageUploadTask> _tasks = <StorageUploadTask>[];

class UploadPage extends StatefulWidget {
  UploadPage();

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  
  @override
  Widget build(BuildContext context) => new DefaultTabController( 
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: Text('Source'),
        centerTitle: true,
        bottom: new TabBar(
          tabs: <Widget>[
            new Tab(
              child: new Text('Gallery'),
            ),
            new Tab(
              child: new Text('Upload'),
            )
          ]
        ),
      ),
      body: new TabBarView(
        children: <Widget>[
          new GalleryScreen(),
          new UploadScreen(),
        ],
      )
    )
  );
}

class GalleryScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new GalleryScreenState();
}

class GalleryScreenState extends State<GalleryScreen> {
  
  Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();

    _stream = Store.instance.sourceRef.snapshots();
  }

  @override
  Widget build(BuildContext context) => new StreamBuilder(
    stream: _stream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
      if (!snapshot.hasData) return new Center(child: new CircularProgressIndicator());

      return snapshot.data != null && snapshot.data.documents.isNotEmpty ? new GridView.builder(
        itemCount: snapshot.data.documents.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              child: new Card(
                elevation: 5.0,
                child: new GridTile(
                  child: new AspectRatio(
                    aspectRatio: 4/3,
                    child: new CachedNetworkImage(
                      imageUrl: snapshot.data.documents[index].data['url'],
                      fit: BoxFit.cover,
                    )
                  ),
                  footer: new Container(
                    height: 35.0,
                    alignment: Alignment.center,
                    color: Colors.black38,
                    child: new Text('data', style: new TextStyle(color: Colors.white70)),
                  ),
                )
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return new SettingScreen(snapshot.data.documents[index].documentID);
              }));
            },
          );
        },
      ) : new Center(child: new Text(AppLocalizations.of(context).noData));
    },
  );
}
class SettingScreen extends StatefulWidget {
  
  SettingScreen(this.documentID);

  final String documentID;

  @override
  State<StatefulWidget> createState() => SettingScreenState();
}
class SettingScreenState extends State<SettingScreen> {
  
  DocumentReference document;
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    document = Store.instance.sourceRef.document(widget.documentID);
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    key: _key,
    appBar: new AppBar(
      title: new Text('Setting'),
      centerTitle: true,
    ),
    body: new StreamBuilder(
      stream: document.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if (!snapshot.hasData) return new Center(child: new CircularProgressIndicator());
        
        return new ListView(
          children: <Widget>[
            new ListTile(
              title: new Text('Url:'),
              subtitle: new Text(snapshot.data['url']),
            ),
            new Divider(),
            new ListTile(
              title: new Text('Use for  '),
              subtitle: new Text(userType[snapshot.data['use']]),
              trailing:  PopupMenuButton<int>(
                onSelected: (int result) {

                  document.setData({
                    'use': result
                  }, merge: true);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text('unknow'),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('use for welcome page'),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text('use for home page banner view'),
                  ),
                ],
              )
            ),
            new Divider(),
            new ListTile(
              title: new Text('Index'),
              subtitle: new Text('${snapshot.data['index'] ?? 0}'),
              onTap: () {
                _key.currentState.showBottomSheet((_){
                  return new Container(
                    padding: new EdgeInsets.all(20.0),
                    child: new TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(),
                        hintText: 'Index',
                      ),
                      onSubmitted: (value) {
                        document.setData({
                          'index': value
                        }, merge: true);
                        ScaffoldState.
                      },
                    )
                  ); 
                });
              },
            )
          ],
        );
      },
    )
  );
}

class UploadScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new UploadScreenState();
}

class UploadScreenState extends State<UploadScreen> {

  
  FirebaseStorage storage = Storage.instance.firebaseStorage;

  String getFileName(String str) {
    return str.substring(str.indexOf('image_picker_'), str.lastIndexOf('?'));
  }

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
            'file': getFileName(url),
            'use': 0
          });
        });
      }
    });

    setState(() {
      _tasks.add(uploadTask);
    });
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

    return new GridTile(
      child: new ListView(
        children: children,
      ),
      footer: new Container(
        alignment: Alignment.centerRight,
        padding: new EdgeInsets.all(10.0),
        child: FloatingActionButton(
          onPressed: () {
            return ImagePicker.pickImage(source: ImageSource.gallery).then((file){
              if(file != null){
                _uploadFile(file);
              }
            });
          },
          child: const Icon(Icons.file_upload),
        ),
      )
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
        subtitle = Text(status);
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
