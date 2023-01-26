import 'package:flutter/material.dart';
import 'package:tasbeh_app/model.dart';
import 'package:tasbeh_app/add_zikr.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: ZikrList(),
  ));
}

class ZikrList extends StatefulWidget {
  ZikrList({Key? key});

  @override
  State<ZikrList> createState() => _ZikrListState();
}

class _ZikrListState extends State<ZikrList> {
  Model model = Model();

  List<String> list = [
    "SubhanAllah",
    "Alhamdulillah",
    "AllahuAkbar",
    "Astagifirullah"
  ];
  List<Model> modelList = <Model>[];

  _rebuildPage() {
    setState(() {});
  }

  getPref() async {
    modelList.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    for (var i = 0; i < list.length; i++) {
      Model model = Model();
      model.name = list[i];
      model.count = preferences.getInt(model.name)!;
      modelList.add(model);
    }
    return modelList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPref(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("Tasbeh App"),
            ),
            body: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    trailing: Text(modelList[index].count.toString(), style: const TextStyle(fontSize: 18),),

                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddZikr(
                                      zikrName: list[index], update: getPref)))
                          .then((value) => _rebuildPage());
                    },
                    title: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        list[index],
                        style: const TextStyle(fontSize: 35),
                      ),
                    ),
                  );
                }),
          );
        });
  }
}
