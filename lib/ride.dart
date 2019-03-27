import 'package:sqflite/sqflite.dart';
import 'package:duration/duration.dart';

import 'package:tachr/database.dart';

class Ride {
  int id;
  int rideTimeSeconds;
  int kilometers;
  int maxSpeed;
  int rideTime;

  Ride();

  Map<String, dynamic> toMap() {
    var _map = <String, dynamic>{
      'rideTimeSeconds': rideTimeSeconds,
      'kilometers': kilometers,
      'maxSpeed': maxSpeed,
      'rideTime': rideTime,
    };
    if (id != null) {
      _map['id'] = id;
    }
    return _map;
  }

  Ride.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    rideTimeSeconds = map['rideTimeSeconds'];
    kilometers = map['kilometers'];
    maxSpeed = map['maxSpeed'];
    rideTime = map['rideTime'];
  }

  static calculateRideTimeFromForm(String hours, String minutes, String seconds) {
    int totalRideTime = 0;

    if (hours.isNotEmpty) {
      totalRideTime += int.parse(hours) * 60 * 60;
    }

    totalRideTime += int.parse(minutes) * 60;
    totalRideTime += int.parse(seconds);

    return totalRideTime;
  }

  static stringDoubetoInteger(String i) {
    double d = double.parse(i);

    return (d * 100).toInt();
  }

  String getHumanRideTime() {
    final d = DateTime.fromMillisecondsSinceEpoch(this.rideTime);
    return d.toString();
  }

  String getHumanKilometers() {
    double k = this.kilometers / 100;

    return k.toString() + ' km';
  }

  String getHumanMaxSpeed() {
    double m = this.maxSpeed / 100;

    return m.toString() + ' km/h';
  }

  String getHumanRideTimeDuration() {
    final d = Duration(seconds: this.rideTimeSeconds);

    return printDuration(d);
  }

  @override
  String toString() {
    return 'Ride{id: $id, rideTimeSeconds: $rideTimeSeconds} / $rideTime';
  }
}

class RideProvider {
  Database db;
  RideProvider();
  
  Future<Null> open() async {
    this.db = await dbOpen();
  }

  Future<List<Ride>> all() async {
    await this.open();
    List<Map> maps = await db.query(
      'rides',
      columns: [
        'id',
        'rideTimeSeconds',
        'kilometers',
        'maxSpeed',
        'rideTime',
      ],
    );
    return maps.map((map) {
      return Ride.fromMap(map);
    }).toList();
  }

  Future<Ride> insert(Ride ride) async {
    await this.open();
    ride.id = await this.db.insert('rides', ride.toMap());
    return ride;
  }

  Future close() async => this.db.close();
}