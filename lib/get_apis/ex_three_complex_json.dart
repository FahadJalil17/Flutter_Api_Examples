import 'dart:convert';

import 'package:api_tech/get_apis/Models/ex_3_user_model.dart';
import 'package:api_tech/get_apis/ex_four_without_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExampleThree extends StatefulWidget {
  const ExampleThree({Key? key}) : super(key: key);

  @override
  State<ExampleThree> createState() => _ExampleThreeState();
}

class _ExampleThreeState extends State<ExampleThree> {

  List<UserModel> userList = [];

  // returning list in future
  Future<List<UserModel>> gerUserAPi() async{
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var data = jsonDecode(response.body.toString());

    if(response.statusCode == 200){
      userList.clear();

      for(Map i in data){
        userList.add(UserModel.fromJson(i));
      }
    }
    else{
      return userList;
    }
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complex Json"),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ExampleFour()));
          }, icon: Icon(Icons.arrow_forward))
        ],
      ),
          body: Column(
            children: [
              Expanded(
                  child: FutureBuilder(
                    future: gerUserAPi(),
               builder: (context, AsyncSnapshot<List<UserModel>> snapshot ){
                 if(!snapshot.hasData){
                   return CircularProgressIndicator();
                 }
                 else{
                 return ListView.builder(
                     itemCount: userList.length,
                     itemBuilder: (context, index){
                   return Card(
                     child: Column(
                       children: [
                         ReusableRow(title: 'Name', value: snapshot.data![index].name.toString()),
                         ReusableRow(title: 'Username', value: snapshot.data![index].username.toString()),
                         ReusableRow(title: 'Email', value: snapshot.data![index].email.toString()),
                         ReusableRow(title: "Address", value: snapshot.data![index].address!.city.toString()),
                         ReusableRow(title: "Latitude", value: snapshot.data![index].address!.geo!.lat.toString())
                       ],
                     )
                   );
                 });
                 }

               },
              )
              )
            ],
          ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value),
        ],
      ),
    );
  }
}

