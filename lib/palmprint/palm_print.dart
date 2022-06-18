import 'package:flutter/material.dart';
import 'data_collection.dart';
import 'recognizer.dart';
void main(){
  runApp(const PalmPrint());
}
class PalmPrint extends StatelessWidget {
  const PalmPrint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'PalmPrint Recognizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IndexPage(),
    );
  }
}
class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}


class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> bottomNavItems = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.add_circle),
        label: "掌纹采集"
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.front_hand),
      label: "掌纹识别"
    ),
  ];
  final List<Text> titles = [
    const Text('掌纹采集'),
    const Text('掌纹识别'),
  ];
  int curIdx = 0;
  final pages = [const DataCollect(),const Recognizer()];

  @override
  void initState() {
    super.initState();
    curIdx = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titles[curIdx],
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: curIdx,
        type: BottomNavigationBarType.fixed,
        onTap: (idx){
          _changePage(idx);
        },
      ),
      body: pages[curIdx],
    );
  }
  void _changePage(int idx){
    if(idx != curIdx){
      setState(
          (){
            curIdx = idx;
          }
      );
    }
  }
}











