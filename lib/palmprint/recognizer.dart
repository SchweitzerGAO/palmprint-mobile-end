import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Recognizer extends StatefulWidget {
  const Recognizer({Key? key}) : super(key: key);

  @override
  State<Recognizer> createState() => _RecognizerState();
}

class _RecognizerState extends State<Recognizer> {
  var _imgPath;
  final _picker = ImagePicker();
  final _dio = Dio();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Text("选择图片或拍照来进行掌纹识别"),
            _viewImage(_imgPath),
            ElevatedButton(onPressed:_takePhoto , child: const Text('拍照')),
            ElevatedButton(onPressed:_openGallery, child: const Text('选择图片')),
            ElevatedButton(onPressed:_recognize, child: const Text('识别'))

          ],
        ),
      )
    );
  }

  Widget _viewImage(imgPath){
    if (_imgPath == null){
      return const Divider();
    }
    return Image.file(File(_imgPath.path));
  }

  void _takePhoto() async {
    var image = await _picker.pickImage(source: ImageSource.camera);
    setState((){
      _imgPath = image;
    });
  }

  void _openGallery() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    setState((){
      _imgPath = image;
    });
  }

  void _recognize() async {
    if(_imgPath == null){
      Fluttertoast.showToast(
          msg: "请选择图片",
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
      return;
    }
    String path = _imgPath.path;

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(path, filename:'recognize.jpg')
    });
    if (kDebugMode) {
      print(formData);
    }
    var response = await _dio.post("http://192.168.1.101:5000/recognize", data: formData);
    if (response.statusCode == 200) {
      if(response.data['code']==200){
        if (response.data['result'] == true){
          var name =response.data['name'];
          Fluttertoast.showToast(
              msg: name+'验证通过',
              gravity: ToastGravity.BOTTOM,
              textColor: Colors.white);
        }
        else {
          Fluttertoast.showToast(
              msg: "验证未通过",
              gravity: ToastGravity.BOTTOM,
              textColor: Colors.white);
        }
      }
      else{
        Fluttertoast.showToast(
            msg: '未检测到手掌',
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white);
      }
    }
    else{
      Fluttertoast.showToast(
          msg: "图片上传失败",
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
    }
  }




}
