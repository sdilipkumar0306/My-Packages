import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  TextEditingController newTodo = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Todo"),
        centerTitle: true,
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(color: Colors.cyan, shape: BoxShape.circle),
        child: IconButton(
            onPressed: () {
              modalBottomSheetMenu(false, null);
            },
            icon: const Icon(Icons.add)),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: db.collection("data").snapshots(),
          builder: (context, snapShot) {
            if (snapShot.hasData) {
              return ListView.builder(
                  itemCount: snapShot.data?.docs.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot<Object?>? mydata = snapShot.data?.docs[index];
                    final iteam = (mydata != null) ? mydata["Name"] : "";
                    return Dismissible(
                      key: Key(iteam),
                      onDismissed: (data) {
                        db.collection("data").doc(mydata?.id).delete();
                      },
                      child: ListTile(
                        title: Text(iteam),
                        onTap: () {
                          setState(() {
                            newTodo.text = iteam;
                          });

                          modalBottomSheetMenu(true, mydata);
                        },
                      ),
                    );
                  });
            } else if (snapShot.hasError) {
              return const Center(
                  child: SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(),
              ));
            } else {
              return const Center(child: Text("No data Found"));
            }
          }),
    );
  }

  void myalertBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              children: [
                TextFormField(
                  controller: newTodo,
                ),
                ElevatedButton(
                    onPressed: () {
                      db.collection("data").add({"Name": newTodo.text, "time": DateTime.now()});
                      Navigator.of(context);
                    },
                    child: const Text("Add"))
              ],
            ),
          );
        });
  }

  void modalBottomSheetMenu(bool isupdate, DocumentSnapshot? data) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (builder) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                width: 200,
                child: TextFormField(
                  controller: newTodo,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    if (isupdate) {
                      db.collection("data").doc(data?.id).update({"Name": newTodo.text, "time": DateTime.now()});
                    } else {
                      db.collection("data").add({"Name": newTodo.text, "time": DateTime.now()});
                    }
                    setState(() {
                      newTodo.clear();
                    });

                    Navigator.pop(context);
                  },
                  child: Text(isupdate ? "Update" : "Add")),
              const SizedBox(height: 20),
            ],
          );
        });
  }
}
