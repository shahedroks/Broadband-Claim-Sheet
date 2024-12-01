import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
class HomePage extends StatefulWidget {
  var id ;
 HomePage({super.key, this.id});
  @override
  State<HomePage> createState() => _HomePageState();
 }
class _HomePageState extends State<HomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List data =[];
  TextEditingController name =TextEditingController();
  TextEditingController user_name=TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController problem = TextEditingController();
  void onGetData ()async {
    try{
      var snapshot = await db.collection('user').get();
      setState(() {
        data = snapshot.docs;
        // data.forEach((elememt){
        //   log("Ëlement =");
        //   log('${elememt['name']}');
        // });
        // print(data);
        // print('ok home page');
      });} catch(err){}}
  void onPostData ()async {

    await db.collection('user').add({
      'name': name.text,
      'user_name': user_name.text,
      'password': password.text,
      'problem': problem.text
    });
    Navigator.of(context).pop();
    setState(() {
  onGetData();
    });
  }

  void onDaleteData({id , user_name})async{
   await db.collection('user').doc(id).delete();

   onGetData();



    Fluttertoast.showToast(
        msg: "Delete $user_name",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
    Navigator.of(context).pop();

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onGetData();
  }
 void onDataDelate()async{

 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          flexibleSpace: Image(image:AssetImage("Assets/Talmuri.jpg"),fit: BoxFit.cover,),
        ),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: data.map((el){
            return Container(
              height: 150.0,
              width: double.infinity,
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(color: Colors.yellow,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(1, 1),
                  blurRadius:3,
                )
              ] ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('${el['name']}',style: TextStyle(
                      fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                          Text('${el['user_name']}',style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),),
                          Text('${el['password']}',style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),),
                          Container(
                            height:45,
                            width: 150,
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text('${el['problem']}',style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(onPressed: (){
                      showDialog(context: context, builder: (BuildContext bc){
                        return AlertDialog(
                          title: Text('Do you want dalete'),
                          actions: [
                           GestureDetector(
                             child: TextButton(onPressed: (){
                               onDaleteData(id: el.id,user_name: el['user_name']);
                             }, child: Text('Yes')),
                           ),
                            TextButton(onPressed: (){
                              Navigator.of(context).pop();
                            }, child: Text('No'))
                          ],
                        );
                      });
                      },style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green
                      ), child: Text('Done',style: TextStyle(fontWeight: FontWeight.bold),))
                    ],
                  )
                ]
              ),
            );  }).toList()

        ),
      ),
        bottomSheet: GestureDetector(
          onTap: (){
            showDialog( context: context, builder: (BuildContext bc){
              return AlertDialog(
                actions: [
                  SizedBox(height: 20,),
                  TextField(controller: name,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: Colors.grey)),labelText: 'Name',
                        focusedBorder: OutlineInputBorder(borderSide:BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(15),)
                    ),),
                  TextField(controller: user_name,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: Colors.grey)),labelText: 'User_name',
                        focusedBorder: OutlineInputBorder(borderSide:BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(15),)
                    ),),
                  TextField(controller:password ,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: Colors.grey)),labelText: 'Password',
                        focusedBorder: OutlineInputBorder(borderSide:BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(15),)
                    ),),
                  TextField(controller:problem ,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),borderSide: BorderSide(color: Colors.grey)),labelText: 'problem',
                        focusedBorder: OutlineInputBorder(borderSide:BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(15),)
                    ),),
                  TextButton(onPressed: (){
                    onPostData();
                  },style: TextButton.styleFrom(backgroundColor: Colors.green), child: Text('Done',))
                ],
              );
            });
          },
          child: Container(
            width: double.infinity,
              child: Icon(Icons.add_circle_outline,size: 50,)),
        ),
      backgroundColor: Colors.white70,
    );
  }
}
