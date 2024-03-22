import 'package:chat_app/models/conversation_messages_response.dart';
import 'package:chat_app/models/users_message.dart';
import 'package:chat_app/presentation/widgets/chat/chat_message.dart';
import 'package:chat_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  //* services
  late ChatService chatService;
  late WebSocketService wssService;
  late AuthService authService;
  
  bool _writing = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    wssService = Provider.of<WebSocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    wssService.addListener(() { 
      if (mounted) {
        _handleListenMessage(wssService.newMessage);
      }
    });
    
    //* get all messages to conversation
    _getConversationMessages(uuid: authService.user.uuid);
  }

  void _getConversationMessages({ required String uuid }) async {
    final List<Msg> messages = await chatService.getConversationMessages(from: uuid, skip: 0);
    final history = messages.map((message) => ChatMessage(
        text: message.message, 
        uuid: message.from, 
        animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 0))..forward()
      )
    );

    setState(() {
      _messages.insertAll(0, history);
    });

    
  }

  @override
  void dispose() {
    super.dispose();
    wssService.removeListener(() { });
    
    for ( ChatMessage message in _messages) {
      message.animationController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final user = chatService.userJustChatting;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: Text(user.name.substring(0,2), style: const TextStyle(fontSize: 12),),
            ),
            const SizedBox(height: 3,),
            Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 14))
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
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
            child: _inputChat(),
          )
        ],
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            
            ///* Text box
            Flexible(
              child: TextField(
                // style: const TextStyle(color: Colors.white),
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
                  hintText: 'Enter Message',
                  // hintStyle: TextStyle(color: Colors.white60)
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
                    data: const IconThemeData(color: Colors.blueAccent, size: 30),
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

  _handleSubmit(String message) {
    if (message.trim().isEmpty) return;
    print(message);
    _textController.clear();
    _focusNode.requestFocus(); //* SOLICITAR EL FOCO
    final newMessage = ChatMessage(
      text: message,
      uuid: authService.user.uuid,
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200)),
    );
    newMessage.animationController.forward();

    _messages.insert(0, newMessage);
    setState(() {
      _writing = false;
    });

    // send message to user
    wssService.handleSendMessage(
      event:  "user-message",
      data: UsersRequestMessage(
        message: message,
        from: authService.user.uuid,
        to: chatService.userJustChatting.uuid,
      )
    );
  } 

  // Add new Message to messages
  _handleListenMessage(dynamic data) {
    if (data == null) return;
    ChatMessage chatMessage = ChatMessage(
      text: data['message'], 
      uuid: data['from'], 
      animationController: AnimationController(vsync: this,duration: const Duration(milliseconds: 200))
    );

    setState(() {
      _messages.insert(0, chatMessage);
    });

    chatMessage.animationController.forward();
  } 
}
