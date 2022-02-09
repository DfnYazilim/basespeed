import 'package:basespeed/models/ispn_model.dart';
import 'package:basespeed/pick_server_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Dio dio = Dio();
  IspnModel selectedServer = IspnModel();
  double _downloadSpeed= 0;
  String durum = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (_) => PickServerScreen()))
                    .then((value) {
                  if (value != null) {
                    setState(() {
                      selectedServer = value;
                    });
                  }
                });
              },
              child: Text(selectedServer.sponsor == null
                  ? "Pick a Server"
                  : "Change a server : ${selectedServer.sponsor}")),
          selectedServer.sponsor == null
              ? Container()
              : ElevatedButton(
                  onPressed: () {
                    _startText();
                  },
                  child: Text("Start")),
          Text("$_downloadSpeed"),
          Text("Status : $durum")
        ],
      ),
    );
  }

  Future<void> _startText() async {
    int listMaxCount = 4;
    int listCount = 0;
    var ls = List.generate(
        listMaxCount,
        (d) => dio.get<ResponseBody>(
              'https://' + selectedServer.host! + '/download?size=25000000',
              options: Options(
                responseType: ResponseType.stream,
              ),
            ));
    var response = await Future.wait(ls);
    var altstartTime = DateTime.now().toUtc().millisecondsSinceEpoch;
    var altendTime = altstartTime;
    List<int> altbytes = [];
    List<double> objects = [];
    response.forEach((element) {
      element.data?.stream.listen((event) {

        altbytes.addAll(event);
        // objects.add(event.length / (altendTime - altstartTime));
        altendTime = DateTime.now().toUtc().millisecondsSinceEpoch;
        var time = (altendTime - altstartTime) / 1000;
        var sizeInBits = altbytes.length * 8;
        double speed = (sizeInBits / time) / (1024 * 1024);
        setState(() {
          durum = "Testing";
          _downloadSpeed = speed;
        });
        objects.add(speed);
      }, onDone: () async {
        listCount += 1;
        if (listCount == listMaxCount) {
          objects.sort((b, a) => b.compareTo(a));
          print('old len : ${objects.length}');
          objects.removeWhere((element) => element.isInfinite);
          // int per30Count = int.parse((objects.length * 0.3).toString());
          // List<double> per30 =  objects.take(per30Count).toList();
          // objects.sort((a, b) => b.compareTo(a));
          // int per10Count = int.parse((objects.length * 0.1).toString());
          // List<double> per10 =  objects.take(per10Count).toList();
          print('first 30 : ${(objects.length * 0.3).toInt()}');
          var newOb = objects.getRange((objects.length * 0.3).toInt(), objects.length-1);
          print('new len : ${newOb.length}');
          print(objects);
          var summ = newOb.reduce((value, element) => value + element);
          print('summ : ${(summ) / newOb.length}');
          setState(() {
            _downloadSpeed = (summ) / newOb.length;
            durum = "Done";
          });
        }
      }, onError: (e) {
        print(e);
        print('download hatası');
        // Globals.toast(msg: appLocalizations.downloadTestFail, error: true);
        // _testing = false;
        // _testingType = 0;
        // notifyListeners();
      }, cancelOnError: false);
    });
  }
}
