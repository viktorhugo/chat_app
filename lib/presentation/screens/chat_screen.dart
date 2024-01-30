import 'package:flutter/material.dart';


class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});


  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: const Text('Vm', style: TextStyle(fontSize: 12),),
            ),
            const SizedBox(height: 3,),
            const Text('Victor Mosquera', style: TextStyle(color: Colors.white, fontSize: 14))
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [

            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => Text('$index'),
                reverse: true,
              )
            ),

            const Divider(height: 1,),

            Container(
              color: Colors.white,
              height: 100,
            )
          ],
        ),
    ),
  );
  }
}