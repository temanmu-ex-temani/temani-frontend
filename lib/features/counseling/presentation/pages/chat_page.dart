import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:temani_frontend/services/shared_preference_service.dart';
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final String sessionId;
  final String receiverUsername;
  final String counselorName;
  const ChatPage({
    super.key,
    this.sessionId = "1233",
    this.receiverUsername = "dummy_peer",
    this.counselorName = "dummy_peer",
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  StompClient? stompClient;
  String? username;
  String? token;
  bool connected = false;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    token = SharedPreferencesService.getToken();
    username = "dummy_penyandang";
    print('[ChatPage] Token: ' + (token ?? 'null'));
    print('[ChatPage] Username: ' + (username ?? 'null'));
    _connectWebSocket();
  }

  void _connectWebSocket() {
    print('[ChatPage] Creating StompClient...');
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://10.0.2.2:8080/chat/websocket',
        onConnect: (frame) {
          print('[ChatPage] WebSocket connected!');
          _onConnect(frame);
        },
        beforeConnect: () async {
          print('[ChatPage] Before connect...');
          await Future.delayed(Duration(milliseconds: 200));
        },
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
        onWebSocketError: (dynamic error) {
          print('[ChatPage] WebSocket error: $error');
          setState(() => connected = false);
        },
        onDisconnect: (frame) {
          print('[ChatPage] WebSocket disconnected');
          setState(() => connected = false);
        },
        onStompError: (frame) {
          print('[ChatPage] STOMP error: ${frame.body}');
          setState(() => connected = false);
        },
        heartbeatIncoming: Duration(seconds: 0),
        heartbeatOutgoing: Duration(seconds: 0),
      ),
    );
    print('[ChatPage] Activating WebSocket...');
    stompClient!.activate();
  }

  void _onConnect(StompFrame frame) {
    print('[ChatPage] _onConnect called');
    setState(() => connected = true);
    stompClient!.subscribe(
      destination: '/user/queue/messages',
      callback: (frame) {
        print('[ChatPage] Received message frame: ${frame.body}');
        if (frame.body != null) {
          final msg = json.decode(frame.body!);
          setState(() {
            messages.add(msg);
          });
          _scrollToBottom();
        }
      },
    );
  }

  void _sendMessage() {
    final content = _controller.text.trim();
    print(
      '[ChatPage] Attempting to send message: $content, connected: $connected',
    );
    if (content.isEmpty || !connected) return;
    final msg = {
      'sessionId': widget.sessionId,
      'receiverUsername': widget.receiverUsername,
      'content': content,
    };
    print('[ChatPage] Sending message: $msg');
    stompClient?.send(
      destination: '/app/chat.send',
      body: json.encode(msg),
      headers: {'Authorization': 'Bearer $token'},
    );
    _controller.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    stompClient?.deactivate();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text(
          widget.counselorName,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg['senderUsername'] == username;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment:
                          isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!isMe)
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(0xFFD6E6FB),
                            child: Text(
                              (msg['senderUsername'] ?? 'C')
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (!isMe) SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isMe ? null : Colors.white,

                              gradient:
                                  isMe
                                      ? LinearGradient(
                                        colors: [
                                          Color(0xFF6EC6F7),
                                          Color(0xFF8ECFFF),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                      : null,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                if (!isMe)
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Text(
                              msg['content'] ?? '',
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Color(0xFFE0E0E0)),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Masukkan teks Anda',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF6EC6F7),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
