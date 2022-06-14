import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
  final _name = TextEditingController();
  final _picker = ImagePicker();
  final _dio = Dio();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text("选择图片或拍照，输入姓名来进行掌纹信息上传"),
              _viewImage(_imgPath),
              ElevatedButton(onPressed:_takePhoto , child: const Text('拍照')),
              ElevatedButton(onPressed:_openGallery, child: const Text('选择图片')),
              Padding(
                  padding:EdgeInsets.all(20),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: '请输入姓名',
                      icon: Icon(Icons.people),
                      hintText: '请输入姓名',
                    ),
                    controller: _name,
                    onChanged: (value){
                      setState(
                          (){
                            _name.text = value;
                            _name.value = TextEditingValue(
                                text: _name.text,
                                selection: TextSelection.fromPosition(
                                    TextPosition(
                                        affinity: TextAffinity.upstream,
                                        offset: _name.text.length
                                    )
                                )
                            );
                          }
                      );
                    },
                  ),
              ),
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
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white);
        return;
      }
      if(_name.text.isEmpty){
        Fluttertoast.showToast(
            msg: "请输入姓名",
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white);
        return;
      }
      String path = _imgPath.path;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(path, filename:'${_name.text}.jpg')
      });
      if (kDebugMode) {
        print(_name);
        print(formData.files);
      }
      var response = await _dio.post("http://192.168.1.101:5000/register", data: formData);
      if (kDebugMode) {
        print(response.data.toString());
      }
      if (response.statusCode == 200) {
        if(response.data['code']==200){
          Fluttertoast.showToast(
              msg: "掌纹信息上传成功",
              gravity: ToastGravity.BOTTOM,
              textColor: Colors.white);
        }
        else{
          Fluttertoast.showToast(
              msg: "未检测到手掌",
              gravity: ToastGravity.BOTTOM,
              textColor: Colors.white);
        }

      }
      else{
        Fluttertoast.showToast(
            msg: "掌纹信息上传失败",
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white);
      }
  }
}

