import 'package:flutter/material.dart';
import 'package:flutter_app/ui/gauge_loc.dart';


class AddGaugeForm extends StatefulWidget {
  @override
  _AddGaugeFormState createState() => new _AddGaugeFormState();
}

class _AddGaugeFormState extends State<AddGaugeForm> {
  bool _pressed = false;
  final _formKey = GlobalKey<FormState>();
  List<String> metricList = [];
  String _name = '';
  String _selectedIndicator = "Temperature";
  String _selectedMetric = "Celcius" ;

  List<String> metricUnitList(){
    if (_selectedIndicator == "Temperature"){
      metricList = [];
      _selectedMetric = "Celcius";
      metricList = ["Celcius","Fahrenheit"];
      return metricList;
    }
    metricList = [];
    _selectedMetric = "mm";
    metricList = ["mm", "inches"];
    return metricList;
  }

  @override
  Widget build(BuildContext context) {
    if(!_pressed)
      return Material(
        color: Colors.white,
        child: Center(
        child: Ink(
        decoration: const ShapeDecoration(
        color: Colors.lightBlue,
        shape: CircleBorder(),
    ),
    child:
    FloatingActionButton(
          child: Icon(Icons.add_circle),
          onPressed: (){
            setState(() {
              _pressed = true;
            });
          }
      ),),),);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getFormWidget(),
      ),
    );
  }

  List<Widget> getFormWidget(){
    List<Widget> formWidget = new List();
    formWidget.add(new TextFormField(
      decoration: InputDecoration(labelText: 'Enter gauge name', hintText: 'Gauge Name'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a name';
        }
        return value;
      },
      onChanged: (value) {
        setState(() {
          _name = value;
        });
      },
    ));
    formWidget.add(new DropdownButton<String>(
      hint: new Text('Select Indicator'),
      items: <String>["Temperature", "Rainfall"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      })
      .toList(),
      value: _selectedIndicator,
      onChanged: (value) {
        setState(() {
          _selectedIndicator = value;
        });
      },
      isExpanded: true,
    ));
    formWidget.add(new DropdownButton<String>(
      hint: new Text('Select Metric'),
      items:  metricUnitList()
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    })
        .toList(),
      value: _selectedMetric,
      onChanged: (value) {
        setState(() {
          _selectedMetric = value;
        });
      },
      isExpanded: true,
    ));
    formWidget.add(new FloatingActionButton(
        tooltip: 'Next',
        child: Icon(Icons.arrow_forward),
      onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context) => GaugeLoc(),
          settings: RouteSettings(arguments: {
            '_name': _name, '_selectedIndicator': _selectedIndicator, '_selectedMetric': _selectedMetric
          })));
        }
      ));
    return formWidget;
  }
}