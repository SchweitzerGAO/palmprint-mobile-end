import 'dart:io';
import 'package:dio/dio.dart';
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
      return const Text("请选择图片");
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
          gravity: ToastGravity.CENTER,
          textColor: Colors.grey);
      return;
    }
    String path = _imgPath.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(path, filename:name)
    });

    var response = await _dio.post("http://127.0.0.1:5000/recognize", data: formData);
    if (response.statusCode == 200) {
      if (response.data['result'] == true){
        Fluttertoast.showToast(
            msg: "验证通过",
            gravity: ToastGravity.CENTER,
            textColor: Colors.white);
      }
      else {
        Fluttertoast.showToast(
            msg: "验证未通过",
            gravity: ToastGravity.CENTER,
            textColor: Colors.white);
      }
    }
    else{
      Fluttertoast.showToast(
          msg: "图片上传失败",
          gravity: ToastGravity.CENTER,
          textColor: Colors.white);
    }
  }




}
