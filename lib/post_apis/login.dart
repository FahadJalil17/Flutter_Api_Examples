import 'dart:convert';

import 'package:api_tech/post_apis/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(String email, password) async{
    try{
      Response response = await post(Uri.parse("https://reqres.in/api/login"),
          body: {
            "email" : email,
            "password" : password
          }
      );

      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        // print(data);
        print(data["token"]);
        const snackBar =  SnackBar(content: Text("Login Successfully"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
          padding: EdgeInsets.all(8),
          dismissDirection: DismissDirection.up,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      else{
        const snackBar = SnackBar(content: Text("Login Failed"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          padding: EdgeInsets.all(8),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Api's"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => UploadImageScreen()));
          }, icon: Icon(Icons.arrow_forward))
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .8,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "Enter Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      )
                  ),
                ),

                SizedBox(height: 20,),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      )

                  ),
                ),

                SizedBox(height: 20,),
                SizedBox(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.of(context).size.width * .8, 50),
                            primary: Colors.green,
                            textStyle: TextStyle(fontSize: 20)),
                        onPressed: (){
                          login(emailController.text.toString(), passwordController.text.toString());
                        }, child: Text("Login"))),


              ],
            ),
          ),
        ),
      ),
    );
  }
}

