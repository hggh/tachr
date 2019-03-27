import 'package:flutter/material.dart';
import 'package:tachr/ride_add.dart';
import 'package:tachr/ride.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tachr',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Rides'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    RideProvider rp = RideProvider();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: new FutureBuilder<List<Ride>>(
          future: rp.all(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data[index].toString()),
                      subtitle: Text(
                        snapshot.data[index].getHumanRideTimeDuration() + 
                        ' at ' + 
                        snapshot.data[index].getHumanRideTime() +
                        ' K: ' +
                        snapshot.data[index].getHumanKilometers()
                        ),
                    );
                  },
                );
              }
              else {
                return new Center(child: new Text("no rides"));
              }
            }
          }
        ),
       
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RideAdd(),
            ),
          );
        },
        tooltip: 'add ride',
        child: Icon(Icons.add),
      ),
    );
  }
}
