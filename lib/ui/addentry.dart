import 'package:flutter/material.dart';
import 'package:flutter_app/ui/mygauge.dart';
import 'package:flutter_app/utils/firebase_auth.dart';
import 'package:intl/intl.dart';

class AddEntryForm extends StatefulWidget {
  @override
  _AddEntryFormState createState() => new _AddEntryFormState();
}

class _AddEntryFormState extends State<AddEntryForm> {
  final _formKey = GlobalKey<FormState>();
  double _amount = 0;
  DateTime _date = new DateTime.now();
  double _duration = 24;
  String _notes = "";

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void submitEntry() async {
    Map data = ModalRoute.of(context).settings.arguments;
    String gaugeID = data["_id"];
    bool res = await AuthProvider()
        .submitEntry(gaugeID, _amount, _date, _duration, _notes);
    if (!res) {
      print("Firestore submission failed");
    }
    if (res) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyGauge()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: Text('Home Page')),
        body: Form(
          key: _formKey,
          child: ListView(
              children: getFormWidget()
          )
        ),
        floatingActionButton: Builder(
          builder: (context) =>
          new FloatingActionButton(
              tooltip: 'Submit',
              child: Icon(Icons.done),
              onPressed: () {
                if (_date.compareTo(DateTime.now()) > 0) {
                  final snackBar = SnackBar(
                      content: Text('You cannot enter a date in the future'));
                  Scaffold.of(context).showSnackBar(snackBar);
                } else {
                  submitEntry();
                }
              })
        ));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    formWidget.add(new ListTile(title: Text("Amount")));
    formWidget.add(new Slider(
        label: "$_amount",
        max: 100,
        min: 0,
        divisions: 100,
        value: _amount,
        onChanged: (value) {
          setState(() {
            _amount = value;
          });
        }));
    formWidget.add(new ListTile(
        title: Text("Start date"),
        subtitle: Text(DateFormat.yMMMMd("en_US").format(_date).toString()),
        trailing: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              selectDate(context);
            })));
    formWidget.add(new ListTile(title: Text("Duration")));
    formWidget.add(new Slider(
        label: "$_duration",
        max: 24,
        min: 0,
        divisions: 24,
        value: _duration,
        onChanged: (value) {
          setState(() {
            _duration = value;
          });
        }));
    formWidget.add(new TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
          labelText: 'Enter notes', hintText: 'Any comments about reading'),
      onChanged: (value) {
        setState(() {
          _notes = value;
        });
      },
    ));
    return formWidget;
  }
}
