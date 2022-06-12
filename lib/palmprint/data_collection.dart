import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class DataCollect extends StatefulWidget {
  const DataCollect({Key? key}) : super(key: key);

  @override
  State<DataCollect> createState() => _DataCollectState();
}

class _DataCollectState extends State<DataCollect> {
  var _imgPath;
  final _picker = ImagePicker();
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

  void _register() async{

  }
}

