import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
class DataCollect extends StatefulWidget {
  const DataCollect({Key? key}) : super(key: key);

  @override
  State<DataCollect> createState() => _DataCollectState();
}

class _DataCollectState extends State<DataCollect> {
  var _imgPath;
  final _picker = ImagePicker();
  final _dio = Dio();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text("选择图片或拍照来进行掌纹信息上传"),
              _viewImage(_imgPath),
              ElevatedButton(onPressed:_takePhoto , child: const Text('拍照')),
              ElevatedButton(onPressed:_openGallery, child: const Text('选择图片')),
              ElevatedButton(onPressed:_register, child: const Text('上传'))

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

  void _register() async{
      if(_imgPath == null){
        Fluttertoast.showToast(
            msg: "请选择图片",
            gravity: ToastGravity.CENTER,
            textColor: Colors.white);
        return;
      }
      String path = _imgPath.path;
      var name = path.substring(path.lastIndexOf("/") + 1, path.length);
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(path, filename:name)
      });

      var response = await _dio.post("http://127.0.0.1:5000/register", data: formData);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "掌纹信息上传成功",
            gravity: ToastGravity.CENTER,
            textColor: Colors.white);
      }
      else{
        Fluttertoast.showToast(
            msg: "掌纹信息上传失败",
            gravity: ToastGravity.CENTER,
            textColor: Colors.white);
      }
  }
}

