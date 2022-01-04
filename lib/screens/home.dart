
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/screens/addtask.dart';
import 'package:todo_app/screens/description.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid='';
  @override
  void initState() {
    // TODO: implement initState
    getUid();
    super.initState();
  }
  void getUid(){
    FirebaseAuth auth= FirebaseAuth.instance;
    final User user = auth.currentUser!;
    setState(() {
      uid=user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        actions: [
          IconButton(
            onPressed: ()async{
              await FirebaseAuth.instance.signOut();
            },
             icon:Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('tasks').doc(uid).collection('mytasks').snapshots(),
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return  Center(child: CircularProgressIndicator(),);
              
            }
            else{
              final docss=snapshot.data!.docs;
              return ListView.builder(
                itemCount:docss.length,
                itemBuilder: (context,index){
                  var time= (docss[index]['timestamp']as Timestamp).toDate();
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>Description(
                          title: docss[index]['title'],
                          description: docss[index]['description'],
                          ))
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.only(left: 10),
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.purple,
                      ),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(docss[index]['title'],style: TextStyle(fontSize: 20),),
                              SizedBox(height: 8,),
                              Text(DateFormat('dd-MM-yyyy   kk:mm').format(time)),
                            ],
                          ),
                          IconButton(
                            onPressed: ()async{
                              await FirebaseFirestore.instance.collection('tasks').doc(uid).collection('mytasks').doc(docss[index]['time']).delete();
                            },
                             icon: Icon(Icons.delete)
                             ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
          ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTask()));
        },
        child: Icon(Icons.add),
        
      ),
    );
  }
}