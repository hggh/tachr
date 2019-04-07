import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:tachr/models/ride.dart';


class RideAdd extends StatefulWidget {
  @override
  RideAddState createState() => new RideAddState();
}

class RideAddForm extends StatefulWidget {
  @override
  RideAddFormState createState() {
    return RideAddFormState();
  }
}

class RideAddFormState extends State<RideAddForm> {
  final _formKey = GlobalKey<FormState>();
  final formHourController = TextEditingController();
  final formMinuteController = TextEditingController();
  final formSecondController = TextEditingController();
  final formKilometerController = TextEditingController();
  final formMaxSpeedController = TextEditingController();
  final formDateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: new Column(
        children: <Widget>[
          new DateTimePickerFormField(
            controller: formDateTimeController,
            editable: true,
            initialDate: DateTime.now(),
            initialTime: TimeOfDay.now(),
            initialValue: DateTime.now(),
            format: DateFormat("yyyy-MM-dd hh:mm:ss"),
            inputType: InputType.both,
            decoration: InputDecoration(labelText: 'Date/Time'),
          ),
          new Text('ride time', textAlign: TextAlign.left),
          new Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: formHourController,
                  decoration: new InputDecoration(labelText: 'hours'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller:formMinuteController,
                  decoration: new InputDecoration(labelText: 'minutes'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter minutes';
                    }
                  },
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller:formSecondController,
                  decoration: new InputDecoration(labelText: 'seconds'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter minutes';
                    }
                  },
                ),
              ),
            ],
            ),
           TextFormField(
             controller: formKilometerController,
             decoration: new InputDecoration(labelText: 'kilometers'),
             keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
             validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter minutes';
                    }
                  },
           ),
           TextFormField(
             controller: formMaxSpeedController,
             decoration: new InputDecoration(labelText: 'max speed'),
             keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
             validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter minutes';
                    }
                  },
           ),
           RaisedButton(
             onPressed: () async {
               if (_formKey.currentState.validate()) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  
                  int totalRideSeconds = Ride.calculateRideTimeFromForm(
                    formHourController.text,
                    formMinuteController.text,
                    formSecondController.text,
                  );

                  var dt = DateTime.parse(formDateTimeController.text);
                  
                  Ride r = Ride();
                  r.rideTimeSeconds = totalRideSeconds;
                  r.kilometers = Ride.stringDoubetoInteger(formKilometerController.text);
                  r.maxSpeed = Ride.stringDoubetoInteger(formMaxSpeedController.text);
                  r.rideTime = dt.millisecondsSinceEpoch;

                  RideProvider rp = RideProvider();
                  await rp.insert(r);
                }
             },
             child: Text('add'),
           ),
        ],
      ),
    );
  }
}

class RideAddState extends State<RideAdd> {
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
      title: 'add new ride',
      home: Scaffold(
        appBar: AppBar(
          title: Text('add new ride'),
        ),
        body: RideAddForm(),
      ),
    );
  }
}