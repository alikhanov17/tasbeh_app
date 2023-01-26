import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddZikr extends StatefulWidget {
  final Function? update;
  String zikrName;

  AddZikr({super.key, required this.zikrName, required this.update});

  @override
  State<AddZikr> createState() => _AddZikrState();
}

class _AddZikrState extends State<AddZikr> {
  int count = 0;
  late SharedPreferences preferences;
  int savedZikrCount = 0;

  _AddZikrState();

  Future<bool> save() async {
    preferences = await SharedPreferences.getInstance();
    await preferences.setInt(
        widget.zikrName, count + preferences.getInt(widget.zikrName)!);
    if (widget.update != null) {
      await widget.update!();
    }
    return true;
  }

  get() async {
    preferences = await SharedPreferences.getInstance();
    savedZikrCount = preferences.getInt(widget.zikrName)!;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        save();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.zikrName),
        ),
        body: Stack(
          children: [
            InkWell(
              child: Container(
                color: Colors.black12,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        count++;
                      });
                    },
                    child: const Text("")),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: Text(
                  "$count",
                  style: const TextStyle(fontSize: 70, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
