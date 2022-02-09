import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'models/ispn_model.dart';

class PickServerScreen extends StatefulWidget {
  const PickServerScreen({Key? key}) : super(key: key);

  @override
  _PickServerScreenState createState() => _PickServerScreenState();
}

class _PickServerScreenState extends State<PickServerScreen> {
  Dio dio = Dio();
  List<IspnModel> _ispnList = <IspnModel>[];

  Future<void> getServers() async {
    var response = await dio.get(
        'https://www.speedtest.net/api/js/servers?engine=js&search=bol&https_functional=true&limit=100');
    print(response.data.toString());
    var users = <IspnModel>[];
    Iterable list = response.data as List;
    users = list.map((model) => IspnModel.fromJson(model)).toList();
    setState(() {
      _ispnList = users;
    });
    _ispnList.sort((b, a) => (b.distance ?? 0) - (a.distance ?? 0));
  }

  @override
  void initState() {
    super.initState();
    getServers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick a server"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) {
                var item = _ispnList[i];
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context, item);
                    },
                    title: Text("${item.sponsor}"),
                    subtitle: Text("Distance : ${item.distance}"),
                  ),
                );
              },
              itemCount: _ispnList.length,
              shrinkWrap: true,
            ),
          )
        ],
      ),
    );
  }
}
