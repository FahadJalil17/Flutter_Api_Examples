import 'dart:convert';

import 'package:api_tech/post_apis/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(String email, password) async{
    try{
      Response response = await post(Uri.parse("https://reqres.in/api/register"),
      body: {
        "email" : email,
        "password" : password
      }
      );

      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        // print(data);
        print(data["token"]);
        const snackBar =  SnackBar(content: Text("Account Created Successfully"),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.grey,
          padding: EdgeInsets.all(8),
          dismissDirection: DismissDirection.up,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      else{
        const snackBar = SnackBar(content: Text("Failed"),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
                        textStyle: TextStyle(fontSize: 20)),
                        onPressed: (){
                          login(emailController.text.toString(), passwordController.text.toString());
                        }, child: Text("Sign Up"))),
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}

