import 'dart:convert';

import 'package:api_tech/get_apis/last_example_complex_json/last_example_complex_json.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExampleFour extends StatefulWidget {
  const ExampleFour({Key? key}) : super(key: key);

  @override
  State<ExampleFour> createState() => _ExampleFourState();
}

class _ExampleFourState extends State<ExampleFour> {

  var data;
  Future<void> getUSerApi() async{
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if(response.statusCode == 200){
      data = jsonDecode(response.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example Four Without Model"),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => LastExampleScreen()));
          }, icon: Icon(Icons.arrow_forward))
        ],
      ),

      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                future: getUSerApi(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }
              else{
               // return Text(data[0]['name'].toString());  // for displaying name on index 0
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index){
                  return Card(
                    child: Column(
                      children: [
                        ReusableRow(title: 'Name', value: data[index]['name'].toString()),
                        ReusableRow(title: "Username", value: data[index]['username'].toString()),
                        ReusableRow(title: "City", value: data[index]['address']['city'].toString()),
                        ReusableRow(title: "Address", value: data[index]['address']['geo']['lat'].toString())
                      ],
                    ),
                  );
                });
              }
            },
          ))
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
