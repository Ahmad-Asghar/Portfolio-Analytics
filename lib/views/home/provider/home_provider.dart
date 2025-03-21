import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common/models/visitor_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../main.dart';


class HomeProvider with ChangeNotifier {
  List<VisitorModel> _visitors = [];
  int _totalVisitors = 0;
  bool _isLoading = false;
  bool _isFetchingMore = false;
  String? _errorMessage;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  static const int _perPage = 15;

  List<VisitorModel> get visitors => _visitors;
  int get totalVisitors => _totalVisitors;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _fcmToken;

  /// Fetch total count separately without loading all documents
  Future<void> fetchTotalCount() async {
    try {
      AggregateQuerySnapshot countSnapshot = await FirebaseFirestore.instance
          .collection('visitors')
          .count()
          .get();
      _totalVisitors = countSnapshot.count??0;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error fetching total count: $e';
      notifyListeners();
    }
  }

  /// Fetch initial 15 visitors
  Future<void> fetchVisitors({bool isRefreshing = false}) async {
    if (!isRefreshing) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      Query query = FirebaseFirestore.instance
          .collection('visitors')
          .orderBy('timestamp', descending: true)
          .limit(_perPage);

      QuerySnapshot snapshot = await query.get();

      _visitors = snapshot.docs
          .map((doc) => VisitorModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }

      _hasMore = snapshot.docs.length == _perPage;
    } catch (e) {
      _errorMessage = 'Error fetching visitors: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreVisitors() async {
    if (!_hasMore || _isFetchingMore) return;
    if (_lastDocument == null && _visitors.isNotEmpty) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      Query query = FirebaseFirestore.instance
          .collection('visitors')
          .orderBy('timestamp', descending: true)
          .startAfter([_lastDocument?.get('timestamp')])
          .limit(_perPage);

      QuerySnapshot snapshot = await query.get();

      List<VisitorModel> moreVisitors = snapshot.docs
          .map((doc) => VisitorModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      if (moreVisitors.isNotEmpty) {
        _visitors.addAll(moreVisitors);
        _lastDocument = snapshot.docs.last;
      }

      _hasMore = snapshot.docs.isNotEmpty && snapshot.docs.length >= _perPage;
    } catch (e) {
      _errorMessage = 'Error fetching more visitors: $e';
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  Future<void> deleteVisitor(String visitorId) async {
    try {
      await FirebaseFirestore.instance.collection('visitors').doc(visitorId).delete();

      // Remove the deleted visitor from the list
      _visitors.removeWhere((visitor) => visitor.visitorId == visitorId);

      // Update total count
      _totalVisitors--;

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error deleting visitor: $e';
      notifyListeners();
    }
  }

  void setFcmToken() async {
    print("Set Token Called");
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    _fcmToken = await messaging.getToken();
    print("FCM Token Generated ${_fcmToken}");
    if(_fcmToken!=null){
      saveTokenToUserData(_fcmToken!);
    }
  }

  void saveTokenToUserData(String fcmToken) {
    print("Setting admin token Id");
    _firestore.collection('admin')
        .doc('pefRuvWPRQRDi1tm45K5')
        .update({
      'admin_fcm': fcmToken,
    }).then((value){
      print("Token Updated");
    }).onError((error, stackTrace){
      print("Error Clearing Token $error");
    });
  }

}



@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // if (message.data.containsKey('type')) {
  //   String type = message.data['type'];
    print('background push notification data:${message.data}');
    print('background push notification data:${message.notification?.body}');
  }
//}


handleNotifications()async{
  InitializationSettings initSettings =const  InitializationSettings(
      android:  AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS:  DarwinInitializationSettings());

  /// on did receive notification response = for when app is opened via notification while in foreground on android
  await flutterLocalNotificationsPlugin.initialize(initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? response) {
      });

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  FirebaseMessaging.instance.getToken().then((token) async {
  });
  FirebaseMessaging.onMessage.listen((message) async {

    BigTextStyleInformation bigTextStyleInformation =
    BigTextStyleInformation(message.notification!.body!, contentTitle: message.notification!.title!);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'portfolio_analytics', 'portfolio_analytics',
        // color: MyColors.primary,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: bigTextStyleInformation,
        ticker: message.notification!.title!);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(
            presentSound: true, presentAlert: true, presentBadge: true));
    flutterLocalNotificationsPlugin.show(
        100, message.notification!.title!, message.notification!.body!, platformChannelSpecifics,
        payload: message.notification!.body);
  });


  FirebaseMessaging.instance.subscribeToTopic('news').then((value) {
  });



}