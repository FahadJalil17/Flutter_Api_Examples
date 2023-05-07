import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// in this example we will pick the image from gallery and upload it on server

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? image; // in this we will store the path of the image which we select from gallery
  final _picker = ImagePicker();
  bool showSpinner = false;

  Future getImage() async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null){
      image = File(pickedFile.path);
      setState(() {

      });
    }

    else{
      const snackBar = SnackBar(content: Text("No Image Selected"),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        padding: EdgeInsets.all(8),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // function for uploading image
  Future<void> uploadImage() async{
    setState(() {
      showSpinner = true;
    });
    var stream = new http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();
    
    var uri = Uri.parse("https://fakestoreapi.com/products");

    var request = new http.MultipartRequest("POST", uri);

    request.fields['title'] = "Static title";

    var multiport = new http.MultipartFile('image', stream, length);

    request.files.add(multiport);

    var response = await request.send();
    print(response.stream.toString());

    if(response.statusCode == 200){
      setState(() {
        showSpinner = false;
      });
      const snackBar =  SnackBar(content: Text("Image Uploaded Successfully"),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        padding: EdgeInsets.all(8),
        dismissDirection: DismissDirection.up,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    else{
      setState(() {
        showSpinner = false;
      });
      const snackBar = SnackBar(content: Text("Failed"),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        padding: EdgeInsets.all(8),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Upload Image"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                getImage();
              },
              child: Container(
                child: image == null ? Center(child: Text("Pick Image"),)   // image will be initially null
                : Container(
                  child: Center(
                    child: Image.file(File(image!.path).absolute,
                    height: 400,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 150,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * .8, 50),
                  primary: Colors.teal,
                  textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: (){
                  uploadImage();
                }, child: Text("Upload"))

          ],
        ),
      ),
    );
  }
}

