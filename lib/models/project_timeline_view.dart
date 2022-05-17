import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sabertech_proctor/models/tab_instance.dart';

class TimelineView{
  final Map<String, double> percentSpent;
  final String projectId;
  final Map<String, dynamic> tabs;
  final int? tabsLength;
  final String userEmail;
  final String userId;
  final num timeStamp;

  TimelineView({
    required this.percentSpent,
    required this.tabs, 
    this.tabsLength, 
    required this.projectId,
    required this.timeStamp,
    required this.userEmail,
    required this.userId
    });

  TimelineView.fromJson(Map<String, dynamic> json)
    : this(
        percentSpent: Map<String, double>.from(json['percentSpent']),
        tabs: Map<String, int>.from(json['tabs']),
        projectId: json['project_id'] as String,
        tabsLength: json['tabsLength'] as int?,
        userEmail: json['user_email'] as String,
        userId: json['user_id'] as String,
        timeStamp: json['time_stamp'] as num,
      );

  Map<String, Object?> toJson() {
    return {
      'percentSpent': percentSpent,
      'tabs': tabs,
      'tabsLength': tabsLength,
      'project_id': projectId,
      'user_email': userEmail,
      'user_id': userId,
      'timeStamp': timeStamp,
    };
  }
}

// class PercentSplit{
//   final String url;
//   final double percent;

//   const PercentSplit({
//     required this.url,
//     required this.percent
//   });


//   PercentSplit.fromJson(Map<String, Object?> json)
//     : this(
//         url: json['url']! as String,
//         percent: json['timeStamp']! as int,
//       );


//   Map<String, Object?> toJson() {
//     return {
//       'url': url,
//       'timeStamp':timeStamp
//     };
//   }
// }