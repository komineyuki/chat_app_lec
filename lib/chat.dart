import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _Chat createState() => _Chat();
}

class _Chat extends State<Chat> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          Expanded(
            child: Scrollbar(
                child: SingleChildScrollView(
                    child: Column(
              children: [
                Center(child: Text("チャットルーム")),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chats")
                        .doc("room1")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.data != null) {
                        var data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        print(data["messages"].length);
                        return Column(children: [
                          for (var i in data["messages"])
                            comment(
                                text: i["text"], uid: i["uid"], date: i["date"])
                        ]);
                      }
                      return const Center(child: Text("メッセージはまだありません。"));
                    }),
              ],
            ))),
          ),
          SizedBox(
              height: 100,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(width: 20),
                Expanded(child: TextField(controller: editingController)),
                IconButton(
                    onPressed: () => sendMessage(editingController.text),
                    icon: const Icon(Icons.send))
              ]))
        ]));
  }

  void sendMessage(String text) {
    Map<String, dynamic> m = {
      "text": editingController.text,
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "date": DateTime.now()
    };
    FirebaseFirestore.instance.collection("chats").doc("room1").set({
      "messages": FieldValue.arrayUnion([m])
    }, SetOptions(merge: true));
    editingController.text = "";
  }

  Widget comment(
      {required String text, required String uid, required Timestamp date}) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("$uid ${date.toDate().toString()}",
                textAlign: TextAlign.start),
            Text(text,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 15)
          ],
        ));
  }
}
