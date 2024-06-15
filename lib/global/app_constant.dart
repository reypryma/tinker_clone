import 'package:firebase_auth/firebase_auth.dart';

class AppConstant {
  // Local Assets
  static const _imageAssets = "assets/images";
  static const logoImage = "$_imageAssets/logo.png";
  static const profileAvatar = "$_imageAssets/profile_avatar.jpg";
  static const likeImage = "$_imageAssets/like.png";
  static const chatImage = "$_imageAssets/chat.png";
  static const favoriteImage = "$_imageAssets/favorite.png";

  // Firebase Assets
  static const firebaseProfileImages = "Profile Images";
  static const firebaseUserCollections = "users";
  static const firebaseUserFavoriteSentCollections = "favoriteSent";
  static const firebaseUserFavoriteReceivedCollections = "favoriteReceived";
  static const firebaseUserLikeReceivedCollections = "likeReceived";
  static const firebaseUserLikeSentCollections = "likeSent";



  // Firebase Url

  static const firebaseDefaultAvatarUrl =
      "https://firebasestorage.googleapis.com/v0/b/fir-learn-2166e.appspot.com/o/Place%20Holder%2Fprofile_avatar.jpg?alt=media&token=7f9a135a-8c6b-41d8-89f4-18289624be82";
}

String currentUserID = FirebaseAuth.instance.currentUser!.uid;
