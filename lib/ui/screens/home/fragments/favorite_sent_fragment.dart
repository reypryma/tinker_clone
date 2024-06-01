import 'package:flutter/material.dart';

class FavoriteSentFavoriteReceivedFragment extends StatefulWidget {
  const FavoriteSentFavoriteReceivedFragment({super.key});

  @override
  State<FavoriteSentFavoriteReceivedFragment> createState() => _FavoriteSentFavoriteReceivedFragmentState();
}


class _FavoriteSentFavoriteReceivedFragmentState extends State<FavoriteSentFavoriteReceivedFragment>
{
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Favorite Sent Favorite Received Screen",
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}