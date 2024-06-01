import 'package:flutter/material.dart';

class LikeSentLikeReceivedFragment extends StatefulWidget
{
  const LikeSentLikeReceivedFragment({super.key});

  @override
  State<LikeSentLikeReceivedFragment> createState() => _LikeSentLikeReceivedFragmentState();
}


class _LikeSentLikeReceivedFragmentState extends State<LikeSentLikeReceivedFragment>
{
  @override
  Widget build(BuildContext context)
  {
    return const Scaffold(
      body: Center(
        child: Text(
          "Like Sent Like Received Screen",
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
