import 'dart:convert';
import 'package:api_tech/get_apis/last_example_complex_json/products_model.dart';
import 'package:api_tech/post_apis/login.dart';
import 'package:api_tech/post_apis/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LastExampleScreen extends StatefulWidget {
  const LastExampleScreen({Key? key}) : super(key: key);

  @override
  State<LastExampleScreen> createState() => _LastExampleScreenState();
}

class _LastExampleScreenState extends State<LastExampleScreen> {

  // This time Response is starting from object not array/list
  Future<ProductsModel> getProductsApi() async{
    final response = await http.get(Uri.parse("https://webhook.site/3f77e029-b46c-4e7a-b4de-db9ca9768a5e"));

    var data = jsonDecode(response.body.toString());  // dynamic
    if(response.statusCode == 200){
    return ProductsModel.fromJson(data);
    }
    else{
      return ProductsModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Api Last Example With Complex Json"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
          }, icon: Icon(Icons.arrow_forward))
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder<ProductsModel>(
                    future: getProductsApi(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return ListView.builder(
                            itemCount: snapshot.data!.data!.length,
                            itemBuilder: (context, index){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(snapshot.data!.data![index].shop!.name.toString()),
                                    subtitle: Text(snapshot.data!.data![index].shop!.shopemail.toString()),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(snapshot.data!.data![index].shop!.image.toString()),
                                    ),
                                  ),

                                  // For Displaying images
                                  Container(
                                    height: MediaQuery.of(context).size.height * .3,
                                    width: MediaQuery.of(context).size.width * 1,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.data![index].images!.length,
                                        itemBuilder: (context, position){
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          height: MediaQuery.of(context).size.height * .25,
                                          width: MediaQuery.of(context).size.width * .5,

                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(snapshot.data!.data![index].images![position].url.toString()),
                                              fit: BoxFit.cover
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  SizedBox(height: 5,),

                                  Icon(snapshot.data!.data![index].inWishlist == false ? Icons.favorite : Icons.favorite_border_outlined),
                                ],
                              );
                            });
                      }
                      else{
                        return CircularProgressIndicator();
                      }

            }))
          ],
        ),
      ),
    );
  }
}

