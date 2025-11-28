import 'package:flutter/material.dart';
import 'package:temanmu/core/constants/_constants.dart';
import 'package:temanmu/services/shared_preference_service.dart';
import 'package:temanmu/core/client/_client.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class ChatHistoryPage extends StatefulWidget {
  final String sessionId;
  final String receiverUsername;
  final String counselorName;

  const ChatHistoryPage({
    super.key,
    required this.sessionId,
    required this.receiverUsername,
    required this.counselorName,
  });

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  String? username;
  String? userId;
  String? token;
  bool _loadingHistory = false;
  String? _historyError;

  @override
  void initState() {
    super.initState();
    _initChatHistory();
  }

  Future<void> _initChatHistory() async {
    token = SharedPreferencesService.getToken();
    username = SharedPreferencesService.getString(PreferencesKeys.displayName);
    userId = SharedPreferencesService.getString(PreferencesKeys.userId);
    print('[ChatHistoryPage] Token: ' + (token ?? 'null'));
    print('[ChatHistoryPage] Username: ' + (username ?? 'null'));
    print('[ChatHistoryPage] UserId: ' + (userId ?? 'null'));
    setState(() {
      _loadingHistory = true;
      _historyError = null;
    });
    await _fetchChatHistory();
    setState(() {
      _loadingHistory = false;
    });
  }

  Future<void> _fetchChatHistory() async {
    final url =
        'http://10.0.2.2:8080/chat-messages/session/${widget.sessionId}';

    try {
      final response = await getIt(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      print('[ChatHistoryPage] History response: ${response.data}');

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
        print(
          '[ChatHistoryPage] Failed to fetch chat history: ${response.data}',
        );
        setState(() {
          _historyError = 'Failed to load chat history: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('[ChatHistoryPage] Error fetching history: $e');
      setState(() {
        _historyError = 'Error loading chat history: $e';
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
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
          '${widget.counselorName} (Riwayat)',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body:
          _loadingHistory
              ? Center(child: CircularProgressIndicator())
              : _historyError != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text(
                      _historyError!,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _initChatHistory();
                      },
                      child: Text('Coba Lagi'),
                    ),
                  ],
                ),
              )
              : messages.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.grey,
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada riwayat chat',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  // Read-only indicator
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lock, color: Colors.blue.shade600, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Konsultasi telah selesai. Anda hanya dapat melihat riwayat chat.',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Chat messages
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
                ],
              ),
    );
  }
}
