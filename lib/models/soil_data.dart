import 'package:cloud_firestore/cloud_firestore.dart';

class SoilData {
  final double? b;
  final double? k;
  final double? mn;
  final double? n;
  final double? p;
  final double? s;
  final double? cu;
  final double? ec;
  final double? fe;
  final double? fertility;
  final double? oc;
  final double? ph;
  final double? zn;  // New Zn attribute
  final DateTime time;

  SoilData({
    required this.b,
    required this.k,
    required this.mn,
    required this.n,
    required this.p,
    required this.s,
    required this.cu,
    required this.ec,
    required this.fe,
    required this.fertility,
    required this.oc,
    required this.ph,
    required this.zn,  // Add Zn to the constructor
    required this.time,
  });

  // Factory method to create an instance from Firestore data
  factory SoilData.fromFirestore(Map<String, dynamic> json) {
    return SoilData(
      b: json['B'].toDouble(),
      k: json['K'].toDouble(),
      mn: json['Mn'].toDouble(),
      n: json['N'].toDouble(),
      p: json['P'].toDouble(),
      s: json['S'].toDouble(),
      cu: json['cu'].toDouble(),
      ec: json['ec'].toDouble(),
      fe: json['fe'].toDouble(),
      fertility: json['fertility'].toDouble(),
      oc: json['oc'].toDouble(),
      ph: json['ph'].toDouble(),
      zn: json['Zn'].toDouble(),  // Add Zn to the factory method
      time: (json['time'] as Timestamp).toDate(),
    );
  }

  // toString method to print the object in a readable format
  @override
  String toString() {
    return '''
SoilData:
  B: $b
  K: $k
  Mn: $mn
  N: $n
  P: $p
  S: $s
  Cu: $cu
  EC: $ec
  Fe: $fe
  Fertility: $fertility
  OC: $oc
  pH: $ph
  Zn: $zn  // Include Zn in the toString method
  Time: $time
''';
  }
}
