import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sabertech_proctor/models/tab_instance.dart';

class UserProjectTimeline {
  final String userEmailId;
  final Timestamp timeStamp;
  final List<TabInstance> tabs;

  const UserProjectTimeline({
    required this.userEmailId,
    required this.timeStamp,
    required this.tabs,
  });


  UserProjectTimeline.fromJson(Map<String, dynamic> json)
    : this(
        userEmailId: json['user_id']! as String,
        timeStamp: json['timeStamp']! as Timestamp,
        tabs: json['tabs']!.map<TabInstance>((json) =>
          TabInstance.fromJson(json)
        ).toList()
      );


  Map<String, Object?> toJson() {
    return {
      'user_id': userEmailId,
      'timeStamp': timeStamp,
      'tabs': tabs
    };
  }
}