import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common/models/visitor_model.dart';

class HomeProvider with ChangeNotifier {
  List<VisitorModel> _visitors = [];
  int _totalVisitors = 0;
  bool _isLoading = false;
  bool _isFetchingMore = false;
  String? _errorMessage;
  DocumentSnapshot? _lastDocument; // Track last document for pagination
  bool _hasMore = true; // To check if more data is available
  static const int _perPage = 15; // Items per page

  List<VisitorModel> get visitors => _visitors;
  int get totalVisitors => _totalVisitors;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

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
          .map((doc) => VisitorModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last; // Store last document for pagination
      }

      _hasMore = snapshot.docs.length == _perPage; // If less than perPage, no more data
    } catch (e) {
      _errorMessage = 'Error fetching visitors: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreVisitors() async {
    debugPrint("Fetch more visitors called...");
    if (!_hasMore || _isFetchingMore) return;
    if (_lastDocument == null && _visitors.isNotEmpty) return; // Avoids stopping the first load

    _isFetchingMore = true;
    notifyListeners();

    try {
      debugPrint("Fetching more visitors...");

      Query query = FirebaseFirestore.instance
          .collection('visitors')
          .orderBy('timestamp', descending: true)
          .startAfter([_lastDocument?.get('timestamp')]) // Ensure proper pagination
          .limit(_perPage);

      QuerySnapshot snapshot = await query.get();
      debugPrint("More Visitors Fetched: ${snapshot.docs.length}");

      List<VisitorModel> moreVisitors = snapshot.docs
          .map((doc) => VisitorModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      if (moreVisitors.isNotEmpty) {
        _visitors.addAll(moreVisitors);
        _lastDocument = snapshot.docs.last; // Update last document
        debugPrint("Last document updated: ${_lastDocument!.id}");
      }

      // Check if there are still more documents to fetch
      _hasMore = snapshot.docs.isNotEmpty && snapshot.docs.length >= _perPage;
    } catch (e) {
      _errorMessage = 'Error fetching more visitors: $e';
      debugPrint(_errorMessage);
      notifyListeners(); // Notify about the error
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }


}
