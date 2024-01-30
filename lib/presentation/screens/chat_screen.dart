import 'package:chat_app/presentation/widgets/chat/chat_message.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final List<ChatMessage> _messages = [
    // const ChatMessage(uuid: '124', text: 'Bien y tu que haces?',),
    // const ChatMessage(uuid: '123', text: 'Hola pepe como estas?',),
  ];
  bool _writing = false;

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
                itemCount: _messages.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => _messages[index],
                reverse: true,
              )
            ),

            const Divider(height: 1,),

            Container(
              color: Colors.white,
              child: _InputChat(),
            )
          ],
        ),
    ),
  );
  }

  Widget _InputChat() {
    
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            
            ///* Text box
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: (value) => _handleSubmit(value),
                onChanged: (text) {
                  setState(() {
                    if(text.trim().isEmpty) {
                      _writing = false;
                    }else {
                      _writing = true;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send Message'
                ),
                focusNode: _focusNode,
              )
            ),

            ///* Button Send
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconTheme(
                    data: const IconThemeData(color: Colors.blueAccent),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: const Icon(Icons.send),
                      onPressed: _writing 
                        ? () => _handleSubmit(_textController.text.trim())
                        : null 
                    ),
                  ),
                )
            )
            
          ],
        ),
      )
    );
  }

  _handleSubmit(String text) {
    if (text.trim().isEmpty) return;
    print(text);
    _textController.clear();
    _focusNode.requestFocus(); ///* SOLICITAR EL FOCO
    final newMessage = ChatMessage(
      text: text,
      uuid: '1253',
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 700)),
    );
    newMessage.animationController.forward();
    _messages.insert(0, newMessage);
    setState(() {
      _writing = false;
    });

    @override
    void dispose(){
      for ( ChatMessage message in _messages) {
        message.animationController.dispose();
      }
    }

  } 

}
