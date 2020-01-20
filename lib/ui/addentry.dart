import 'package:flutter/material.dart';

class AddEntryForm extends StatefulWidget {
  @override
  _AddEntryFormState createState() => new _AddEntryFormState();
}

class _AddEntryFormState extends State<AddEntryForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> metricList = [];
  double _amount = 0;
  DateTime _date = new DateTime.now();
  double _duration = 24;
  String _notes = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text('Home Page')
        ),
        body: Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getFormWidget(),
          mainAxisSize: MainAxisSize.min),
    ));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    formWidget.add(
      new SizedBox(width: 10.0, height: 50.0)
    );
    formWidget.add(Text(
      'Amount',
      textAlign: TextAlign.left,
    ));
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
//    formWidget.add(
//      new DayPicker(selectedDate: _date, currentDate: DateTime.now(), onChanged: (value){
//        setState(() {
//          _date = value;
//        });
//        }, firstDate: DateTime(1,1,1), lastDate: DateTime(12,12,12), displayedMonth: DateTime.now(),
//      )
//    );
    formWidget.add(Text(
      'Duration',
      textAlign: TextAlign.left,
    ));
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
