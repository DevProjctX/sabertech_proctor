import 'package:cloud_firestore/cloud_firestore.dart';

class TabInstance{
  final String url;
  final int timeStamp;

  const TabInstance({
    required this.url,
    required this.timeStamp
  });


  TabInstance.fromJson(Map<String, Object?> json)
    : this(
        url: json['url']! as String,
        timeStamp: json['timeStamp']! as int,
      );


  Map<String, Object?> toJson() {
    return {
      'url': url,
      'timeStamp':timeStamp
    };
  }
}