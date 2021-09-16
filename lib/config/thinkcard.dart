import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ThinkCardApp {
  static const String appName = 'e-Shop';
  static AudioPlayer player = AudioPlayer();
  static AudioCache cache = new AudioCache();

  static DateFormat timeFormat = DateFormat('E, h:mm a, D');
  static DateFormat timeFormat2 = DateFormat('y-MM-d');
  static SharedPreferences sharedPreferences;
  static FirebaseUser user;
  static FirebaseAuth auth;
  static Firestore firestore;

  static String collectionUser = "users";
  static String collectionOrders = "orders";
  static String userCartList = 'userCart';
  static String subCollectionAddress = 'userAddress';

  static final String userName = 'name';
  static final String fullName = 'fullName';
  static final String phoneNumber = 'phoneNumber';
  static final String userEmail = 'email';
  static final String userPhotoUrl = 'photoUrl';
  static final String userUID = 'uid';
  static final String userAvatarUrl = 'url';

  static final String addressID = 'addressID';
  static final String totalAmount = 'totalAmount';
  static final String productID = 'productIDs';
  static final String paymentDetails = 'paymentDetails';
  static final String orderTime = 'orderTime';
  static final String isSuccess = 'isSuccess';

  static String bgMusic = "bgMusic";
  static String clickSound = "clickSound";
  static String allowUsers = "allowUsers";
  static String Sub = "Sub";

  static String currentPage = "currentPage";
}
