import 'package:flutter/material.dart';

class SwipingFragment extends StatefulWidget
{
  const SwipingFragment({super.key});

  @override
  State<SwipingFragment> createState() => _SwipingFragmentState();
}

class _SwipingFragmentState extends State<SwipingFragment>
{
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Swiping Fragment",
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
