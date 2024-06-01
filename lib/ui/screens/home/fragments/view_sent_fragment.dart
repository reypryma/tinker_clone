import 'package:flutter/material.dart';

class ViewSentViewReceivedFragment extends StatefulWidget {
  const ViewSentViewReceivedFragment({super.key});

  @override
  State<ViewSentViewReceivedFragment> createState() => _ViewSentViewReceivedFragmentState();
}

class _ViewSentViewReceivedFragmentState extends State<ViewSentViewReceivedFragment> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "View Sent View Received Fragment",
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
