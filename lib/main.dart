import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {

  void _onListItemPres(DocumentReference reference) {
    Firestore.instance.runTransaction((trans) async {
      DocumentSnapshot doc = await trans.get(reference);
      await trans.update(reference, {'votes': doc.data['votes'] + 1});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("bands").snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        _onListItemPres(snapshot.data.documents[index].reference);
                      },
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(snapshot.data.documents[index]['name']),
                              Spacer(),
                              Text(snapshot.data.documents[index]['votes']
                                  .toString())
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}

//
//
//
//
//
//
//
//
