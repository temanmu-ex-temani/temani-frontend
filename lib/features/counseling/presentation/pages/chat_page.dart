import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:temanmu/core/constants/_constants.dart';
import 'package:temanmu/services/shared_preference_service.dart';
import 'package:temanmu/features/counseling/presentation/cubit/counseling_sessions_cubit.dart';
import 'package:temanmu/features/main/presentation/cubit/upcoming_sessions_cubit.dart';
import 'package:temanmu/services/depedencies/di.dart';
import 'package:temanmu/services/toast_service.dart';
import 'dart:convert';
import 'package:temanmu/core/client/_client.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String sessionId;
  final String receiverUsername;
  final String counselorName;
  final String? scheduleId; // Add scheduleId parameter
  const ChatPage({
    super.key,
    required this.sessionId,
    required this.receiverUsername,
    required this.counselorName,
    this.scheduleId,
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
  String? userId;
  String? token;
  bool connected = false;
  bool _loadingHistory = false;
  String? _historyError;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    token = SharedPreferencesService.getToken();
    username = SharedPreferencesService.getString(PreferencesKeys.displayName);
    userId = SharedPreferencesService.getString(PreferencesKeys.userId);
    print('[ChatPage] Token: ' + (token ?? 'null'));
    print('[ChatPage] Username: ' + (username ?? 'null'));
    print('[ChatPage] UserId: ' + (userId ?? 'null'));
    setState(() {
      _loadingHistory = true;
      _historyError = null;
    });
    await _fetchChatHistory();
    setState(() {
      _loadingHistory = false;
    });

    _connectWebSocket();
  }

  Future<void> _fetchChatHistory() async {
    final url =
        'http://10.0.2.2:8080/chat-messages/session/${widget.sessionId}';
    try {
      final response = await getIt(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      print('[ChatPage] Fetching chat history: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data is String
                ? json.decode(response.data)
                : response.data;
        setState(() {
          messages = data.cast<Map<String, dynamic>>();
          _historyError = null;
        });
        _scrollToBottom();
      } else {
        print('[ChatPage] Failed to fetch chat history: ${response.data}');
        setState(() {
          _historyError = 'Failed to fetch chat history.';
        });
      }
    } catch (e) {
      print('[ChatPage] Error fetching chat history: $e');
      setState(() {
        _historyError = 'Error fetching chat history.';
      });
    }
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
          if (mounted) {
            setState(() => connected = false);
          }
        },
        onDisconnect: (frame) {
          print('[ChatPage] WebSocket disconnected');
          if (mounted) {
            setState(() => connected = false);
          }
        },
        onStompError: (frame) {
          print('[ChatPage] STOMP error: ${frame.body}');
          if (mounted) {
            setState(() => connected = false);
          }
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
    if (mounted) {
      setState(() => connected = true);
    }
    stompClient!.subscribe(
      destination: '/user/queue/messages/${widget.sessionId}',
      callback: (frame) {
        print('[ChatPage] Received message frame: ${frame.body}');
        if (frame.body != null && mounted) {
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
      'receiverId': widget.receiverUsername, // Now using receiverId field
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

  bool _isPeer() {
    final roles = SharedPreferencesService.getStringList(PreferencesKeys.roles);
    // Prioritize CLIENT role - if user has CLIENT role, treat as CLIENT
    // even if they also have PEER role
    if (roles != null && 
        (roles.contains('CLIENT') || roles.contains('ROLE_CLIENT'))) {
      return false;
    }
    return roles != null &&
        (roles.contains('PEER') || roles.contains('ROLE_PEER'));
  }

  Future<void> _endSessionWithId(String scheduleId) async {
    if (scheduleId.isEmpty) {
      ToastService.show(context, 'Schedule ID tidak ditemukan');
      return;
    }

    final cubit = get<CounselingSessionsCubit>();
    final success = await cubit.updateScheduleStatus(
      scheduleId: scheduleId,
      status: 'COMPLETED',
    );

    if (success) {
      ToastService.show(context, 'Sesi berhasil diakhiri');
      
      // Refresh the upcoming sessions on the homepage
      // Don't await - let it refresh in the background
      try {
        final upcomingSessionsCubit = get<UpcomingSessionsCubit>();
        upcomingSessionsCubit.loadUpcomingSessions();
      } catch (e) {
        // UpcomingSessionsCubit might not be available, ignore
        print('Could not refresh upcoming sessions: $e');
      }
      
      // Use post-frame callback to ensure Navigator is ready
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    } else {
      ToastService.show(context, 'Gagal mengakhiri sesi');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPeer = _isPeer();
    // Use sessionId as fallback for scheduleId since they're the same
    final scheduleId = widget.scheduleId ?? widget.sessionId;
    
    // Debug logging
    print('[ChatPage] isPeer: $isPeer');
    print('[ChatPage] scheduleId: $scheduleId');
    print('[ChatPage] widget.scheduleId: ${widget.scheduleId}');
    print('[ChatPage] widget.sessionId: ${widget.sessionId}');
    
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
          if (isPeer)
            TextButton(
              onPressed: () => _endSessionWithId(scheduleId),
              child: Text(
                'Akhiri',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            IconButton(
              icon: Icon(Icons.call, color: Colors.black),
              onPressed: () {},
            ),
        ],
      ),
      body:
          _loadingHistory
              ? Center(child: CircularProgressIndicator())
              : _historyError != null
              ? Center(
                child: Text(
                  _historyError!,
                  style: TextStyle(color: Colors.red),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 8,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMe = msg['senderId'] == userId;
                        String time = '';
                        if (msg['timestamp'] != null) {
                          try {
                            final dt = DateTime.parse(msg['timestamp']);
                            time = DateFormat('HH.mm').format(dt);
                          } catch (_) {}
                        }
                        return Align(
                          alignment:
                              isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
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
                                if (isMe && time.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Text(
                                      time,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
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
                                            color: Colors.black.withOpacity(
                                              0.03,
                                            ),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                      ],
                                    ),
                                    child: Text(
                                      msg['content'] ?? '',
                                      style: TextStyle(
                                        color:
                                            isMe
                                                ? Colors.white
                                                : Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                if (!isMe && time.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(
                                      time,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                if (isMe) SizedBox(width: 8),
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
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
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
