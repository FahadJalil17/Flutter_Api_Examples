import 'dart:convert';

import 'package:api_tech/get_apis/Models/ex_1_posts_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ex-two_custom_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // we created list because we don't have array name in Api
  List<PostsModel> postList = [];

  Future<List<PostsModel>> getPostApi() async{
   final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
   var data = jsonDecode(response.body.toString());  // now this data contains whole array
   if(response.statusCode == 200){
     // postList.clear(); // if you do hot refresh it will not be reload => last step

     for(Map i in data){
       postList.add(PostsModel.fromJson(i));  // in postlist we are adding data => all data is stored in this
     }
   }
   else{
     return postList;
   }

   return postList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ExampleTwo()));
          }, icon: Icon(Icons.arrow_forward))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getPostApi(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){ // means no data
                    return CircularProgressIndicator();
                  }
                  else{
                    return ListView.builder(
                        itemCount: postList.length,
                        itemBuilder: (context, index){
                      // return Text(index.toString());
                          return Card(
                            child: Column(
                              children: [
                                // instead of list tile it can be display in column
                                ListTile(
                                  contentPadding: EdgeInsets.all(5),
                                  tileColor: Colors.amber,
                                  leading: Text(postList[index].id.toString()),
                                  title: Text('Title : \n' + postList[index].title.toString() + '\n', style: TextStyle(fontWeight: FontWeight.bold),),
                                  subtitle: Text('Description : \n' + postList[index].body.toString(),),
                                ),
                              ],
                            ),
                          );
                    });
                  }
            }),
          )

        ],
      ),
    );
  }
}

