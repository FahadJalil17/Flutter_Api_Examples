import 'dart:convert';

import 'package:api_tech/get_apis/ex_three_complex_json.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExampleTwo extends StatefulWidget {
  const ExampleTwo({Key? key}) : super(key: key);

  @override
  State<ExampleTwo> createState() => _ExampleTwoState();
}

class _ExampleTwoState extends State<ExampleTwo> {
  
  List<Photos> photosList = [];

  Future<List<Photos>> getPhotosApi() async{
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){

      // photosList.clear();
      for(Map i in data){
        Photos photos = Photos(title: i['title'], url: i['url'], id: i['id']); // through models we parse data
        photosList.add(photos);
      }
    }
    else{
      return photosList;
    }
    return photosList;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example Two Without Model"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ExampleThree()));
          }, icon: Icon(Icons.arrow_forward))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getPhotosApi(),
                builder: (context,AsyncSnapshot<List<Photos>> snapshot){
              if(!snapshot.hasData){
                return CircularProgressIndicator();
              }

              else{
                return ListView.builder(
                    itemCount: photosList.length,
                    itemBuilder: (context, index){
                  return Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(5),
                      leading: CircleAvatar(backgroundImage: NetworkImage(snapshot.data![index].url.toString()),),
                      // trailing: Image(image: NetworkImage(snapshot.data![index].url),),
                      title: Text("Notes id: " + snapshot.data![index].id.toString()),
                      subtitle: Text(snapshot.data![index].title.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                      // subtitle: Text(photosList[index].title.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
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

// Example Two Without Model => Building List with JSON Data with custom Model
class Photos{
  String title, url;
  int id;
  Photos({required this.title, required this.url, required this.id});
}

