import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  const AddTask({ Key? key }) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future addTaskToFirebase() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user=await auth.currentUser!;
    String uid = user.uid;
    var time= DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
          'title' : titleController.text,
          'description': descriptionController.text,
          'time':time.toString(),
          'timestamp': time,
        });
  Fluttertoast.showToast(msg: "task added");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Task"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'Enter title'
                )
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'Enter description'
                )
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child: ElevatedButton(
                
                onPressed: (){
                  addTaskToFirebase();
                  
                },
                 child: Text("Submit"),
                 ),
            )
          ],
        ),
      ),
    );
  }
}