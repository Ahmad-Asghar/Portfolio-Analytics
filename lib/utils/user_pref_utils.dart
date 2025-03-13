
//
// Future<void> saveVisitorData() async {
//   try {
//     // Step 1: Get Public IP Address
//     var ipResponse = await http.get(Uri.parse('https://api64.ipify.org?format=json'));
//     if (ipResponse.statusCode == 200) {
//       var ip = jsonDecode(ipResponse.body)['ip'];
//
//       // Step 2: Fetch Location Data from IP
//       var locationResponse = await http.get(Uri.parse('http://ip-api.com/json/$ip'));
//       if (locationResponse.statusCode == 200) {
//         var locationData = jsonDecode(locationResponse.body);
//
//         // Step 3: Convert JSON to Model
//         VisitorModel visitor = VisitorModel.fromJson(locationData);
//
//         // Step 4: Save Model to Firestore
//         await FirebaseFirestore.instance.collection('visitors').add(visitor.toJson());
//
//         print('Visitor data saved successfully: ${visitor.toJson()}');
//       }
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }
//
//
//
//
//
//
// void openWhatsApp() async {
//   String phoneNumber = '+923203838849';
//   String url = 'https://wa.me/$phoneNumber';
//
//   if (await canLaunchUrl(Uri.parse(url))) {
//     await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//   } else {
//     throw 'Could not launch $url';
//   }
// }
//
//
// showToast(String message){
//   Fluttertoast.showToast(
//     webPosition: 'center',
//     webBgColor: "linear-gradient(to right, #fd5c39, #fd5c39)",
//     msg: message,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     backgroundColor: Colors.black,
//     textColor: Colors.white,
//     fontSize: 14.0
//   );
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp? timestamp) {
  DateTime? dateTime = timestamp?.toDate();
  String formattedDate = DateFormat("d MMMM h:mm a").format(dateTime!);
  return formattedDate;
}


String getGreeting() {
  DateTime now = DateTime.now();
  int hour = now.hour;

  if (hour >= 5 && hour < 12) {
    return "Good Morning";
  } else if (hour >= 12 && hour < 16) {
    return "Good Noon";
  } else if (hour >= 16 && hour < 19) {
    return "Good Afternoon";
  } else if (hour >= 19 && hour < 21) {
    return "Good Evening";
  } else {
    return "Good Night";
  }
}

