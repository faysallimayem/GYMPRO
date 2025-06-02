import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_lib;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';
import '../models/coach_model.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:photo_view/photo_view.dart';

// ignore_for_file: must_be_immutable
class ChatScreen extends StatefulWidget {
  final Coach coach;

  const ChatScreen({
    super.key,
    required this.coach,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  late types.User chatUser;
  late types.User currentUser;
  List<types.Message> messageList = [];
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  int? conversationId;
  bool isLoading = true;
  String? currentUserId;
  Set<String> processedMessageIds = {}; // Track processed message IDs
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  
  // Store image bytes for local images to display on web
  Map<String, Uint8List> localImageBytes = {};
  
  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      final userData = await _authService.getUserDetails();
      if (userData == null || userData['id'] == null) {
        throw Exception('Could not get user details');
      }

      setState(() {
        currentUserId = userData['id'].toString();
        chatUser = types.User(
          id: widget.coach.id.toString(),
          firstName: widget.coach.fullName,
          imageUrl: widget.coach.photoUrl != null ? _getFullImageUrl(widget.coach.photoUrl!) : null,
        );
        currentUser = types.User(
          id: currentUserId!,
          firstName: userData['firstName'] ?? 'Me',
          lastName: userData['lastName'],
        );
      });

      conversationId = await _chatService.getOrCreateConversation(
        currentUserId!,
        widget.coach.id.toString(),
      );
      
      _chatService.conversationId = conversationId;
      
      connectToSocket();
      await loadPreviousMessages();
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error initializing chat: $e');
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize chat: $e')),
        );
      }
    }
  }

  void connectToSocket() {
    socket = IO.io(_chatService.getSocketUrl(), <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.onConnect((_) {
      print('Socket.IO Connected');
      if (conversationId != null) {
        socket.emit('joinConversation', {
          'conversationId': conversationId,
        });
      }
    });

    socket.on('joinedConversation', (data) {
      print('Joined conversation: $data');
      // Emit readReceipt on join as well for extra reliability
      if (conversationId != null && currentUserId != null) {
        socket.emit('readReceipt', {
          'conversationId': conversationId,
          'userId': currentUserId,
        });
      }
    });

    socket.on('newMessage', (data) {
      print('Received new message: $data');
      try {
        if (data['conversationId'].toString() == conversationId.toString()) {
          final messageId = data['id'].toString();
          
          // Skip messages sent by the current user to avoid duplicates
          // since we already add them locally when sending
          if (data['senderId'].toString() == currentUserId) {
            print('Skipping own message to avoid duplicate: $messageId');
            return;
          }
          
          if (processedMessageIds.contains(messageId)) {
            print('Message $messageId already processed, skipping');
            return;
          }

          final timestamp = data['createdAt'] != null 
            ? DateTime.parse(data['createdAt']).millisecondsSinceEpoch
            : DateTime.now().millisecondsSinceEpoch;
          
          final author = types.User(
            id: data['senderId'].toString(),
            firstName: data['senderId'].toString() == widget.coach.id.toString() 
              ? widget.coach.fullName 
              : null,
          );

          types.Message newMessage;
          
          if (data['type'] == 'image' && data['imageUrl'] != null) {
            final imageUrl = data['imageUrl'].startsWith('http') 
              ? data['imageUrl']
              : '${_chatService.getBaseUrl()}${data['imageUrl']}';
              
            print('Creating image message with URL: $imageUrl');
            
            // Calculate reasonable dimensions based on screen size
            final screenWidth = MediaQuery.of(context).size.width;
            final imageWidth = screenWidth * 0.5; // 50% of screen width
            final imageHeight = screenWidth * 0.4; // 40% of screen width
            
            newMessage = types.ImageMessage(
              author: author,
              id: messageId,
              name: data['filename'] ?? 'image.jpg',
              size: data['size'] ?? 0,
              uri: imageUrl,
              width: imageWidth,
              height: imageHeight,
              createdAt: timestamp,
            );
          } else {
            newMessage = types.TextMessage(
              author: author,
              id: messageId,
              text: data['content'] ?? '',
              createdAt: timestamp,
            );
          }

          if (mounted) {
            setState(() {
              processedMessageIds.add(messageId);
              // Insert at the beginning for proper ordering
              messageList = [...messageList, newMessage];
            });
            
            // If the new message is from the other user, mark it as read immediately
            if (data['senderId'].toString() != currentUserId) {
              socket.emit('readReceipt', {
                'conversationId': conversationId,
                'userId': currentUserId,
              });
            }
          }
        }
      } catch (e, stackTrace) {
        print('Error processing new message: $e');
        print('Stack trace: $stackTrace');
      }
    });

    socket.onDisconnect((_) => print('Socket.IO Disconnected'));
    socket.onError((error) {
      print('Socket.IO Error: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection error. Messages may be delayed.')),
        );
      }
    });

    socket.connect();
  }

  Future<void> loadPreviousMessages() async {
    try {
      if (conversationId == null) return;
      
      final messages = await _chatService.getConversationMessages(conversationId!);
      print('Loaded messages: ${messages.length}');
      
      final chatMessages = messages.map((msg) {
        if (msg.type == 'image' && msg.imageUrl != null) {
          final imageUrl = msg.imageUrl!.startsWith('http') 
            ? msg.imageUrl!
            : '${_chatService.getBaseUrl()}${msg.imageUrl}';
            
          final screenWidth = MediaQuery.of(context).size.width;
          final imageWidth = screenWidth * 0.5;
          final imageHeight = screenWidth * 0.4;
          
          return types.ImageMessage(
            author: types.User(
              id: msg.senderId,
              firstName: msg.senderId == widget.coach.id.toString() 
                ? widget.coach.fullName 
                : null,
            ),
            id: msg.id,
            name: 'image.jpg',
            size: 0,
            uri: imageUrl,
            width: imageWidth,
            height: imageHeight,
            createdAt: msg.createdAt.millisecondsSinceEpoch,
          );
        } else {
          return types.TextMessage(
            author: types.User(
              id: msg.senderId,
              firstName: msg.senderId == widget.coach.id.toString() 
                ? widget.coach.fullName 
                : null,
            ),
            id: msg.id,
            text: msg.content,
            createdAt: msg.createdAt.millisecondsSinceEpoch,
          );
        }
      }).toList();

      // Sort messages by timestamp (oldest first)
      chatMessages.sort((a, b) {
        final aTime = a.createdAt ?? 0;
        final bTime = b.createdAt ?? 0;
        return aTime.compareTo(bTime);
      });
      
      if (mounted) {
        setState(() {
          messageList = chatMessages;
          // Add all loaded message IDs to processed set
          processedMessageIds.addAll(chatMessages.map((msg) => msg.id));
        });
      }
    } catch (e) {
      print('Error loading messages: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load messages: $e')),
        );
      }
    }
  }

  Future<void> _handleImageSelection() async {
    try {
      final result = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1440,
      );

      if (result != null && mounted && conversationId != null && currentUserId != null) {
        final bytes = await result.readAsBytes();
        final image = await decodeImageFromList(bytes);
        
        // Get file extension and mime type
        String filename = result.name ?? 'image.jpg';
        // Clean up filename - remove any blob URLs
        filename = filename.split('.').first.split('blob:').first;
        final extension = result.path.split('.').last.toLowerCase().split('blob:').first;
        
        // Determine MIME type based on extension
        String mimeType;
        switch (extension) {
          case 'jpg':
          case 'jpeg':
            mimeType = 'image/jpeg';
            break;
          case 'png':
            mimeType = 'image/png';
            break;
          case 'gif':
            mimeType = 'image/gif';
            break;
          default:
            mimeType = 'image/jpeg'; // Default to JPEG
        }
        
        // Create data URI with proper MIME type prefix
        final base64Str = 'data:$mimeType;base64,${base64Encode(bytes)}';
        print('Image data length: ${base64Str.length}');
        print('MIME type: $mimeType');
        
        final messageId = DateTime.now().millisecondsSinceEpoch.toString();
        
        if (processedMessageIds.contains(messageId)) {
          return;
        }

        // Create and add the image message immediately to local list
        final localImageUri = kIsWeb ? 'local_image_$messageId' : result.path;
        
        // Store bytes for web display
        if (kIsWeb) {
          localImageBytes[localImageUri] = bytes;
        }
        
        final imageMessage = types.ImageMessage(
          author: currentUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          height: image.height.toDouble(),
          id: messageId,
          name: '$filename.$extension',
          size: bytes.length,
          uri: localImageUri,
          width: image.width.toDouble(),
        );

        setState(() {
          processedMessageIds.add(messageId);
          messageList.add(imageMessage);
        });

        // Send image through Socket.IO
        socket.emit('sendImageMessage', {
          'senderId': currentUserId,
          'conversationId': conversationId,
          'imageBuffer': base64Str,
          'filename': '$filename.$extension',
          'type': 'image',
          'width': image.width,
          'height': image.height,
          'size': bytes.length,
          'mimeType': mimeType
        });
        
        print('Image message sent via socket');
      }
    } catch (e) {
      print('Error handling image selection: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send image: $e')),
        );
      }
    }
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    if (conversationId == null || currentUserId == null || message.text.trim().isEmpty) {
      return;
    }

    try {
      print('Sending message via Socket.IO');
      final messageId = DateTime.now().millisecondsSinceEpoch.toString();
      
      if (processedMessageIds.contains(messageId)) {
        print('Message $messageId already processed, skipping send');
        return;
      }

      final textMessage = types.TextMessage(
        author: currentUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: messageId,
        text: message.text,
      );

      setState(() {
        processedMessageIds.add(messageId);
        messageList.add(textMessage);
      });

      socket.emit('sendMessage', {
        'senderId': currentUserId,
        'conversationId': conversationId,
        'content': message.text,
      });

    } catch (e) {
      print('Error sending message: $e');
      if (mounted) {
        setState(() {
          messageList.removeLast();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chat_lib.Chat(
              messages: messageList.reversed.toList(),
              onSendPressed: _handleSendPressed,
              onAttachmentPressed: _handleImageSelection,
              onMessageTap: (context, message) {
                if (message is types.ImageMessage) {
                  showDialog(
                    context: context,
                    builder: (context) => ImagePreviewDialog(imageUrl: message.uri),
                  );
                }
              },
              user: currentUser,
              showUserNames: true,
              theme: chat_lib.DefaultChatTheme(
                primaryColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.white,
                inputBackgroundColor: Colors.grey[200]!,
                inputTextColor: Colors.black,
                inputTextCursorColor: Theme.of(context).primaryColor,
                sentMessageBodyTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                receivedMessageBodyTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                messageInsetsHorizontal: 8,
                messageInsetsVertical: 8,
              ),
              customMessageBuilder: (types.CustomMessage message, {required int messageWidth}) {
                return Container(); // Return empty container for custom messages
              },
              imageMessageBuilder: (types.ImageMessage message, {required int messageWidth}) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      // Only show preview for network images, not local file paths
                      if (message.uri.startsWith('http')) {
                        showDialog(
                          context: context,
                          builder: (context) => ImagePreviewDialog(imageUrl: message.uri),
                        );
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                          maxHeight: MediaQuery.of(context).size.width * 0.4,
                        ),
                        child: _buildImageWidget(message),
                      ),
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      title: Row(
        children: [
          if (widget.coach.photoUrl != null)
            CircleAvatar(
              backgroundImage: NetworkImage(_getFullImageUrl(widget.coach.photoUrl!)),
              onBackgroundImageError: (exception, stackTrace) {
                print('Failed to load coach profile image: $exception');
              },
              radius: 20,
            )
          else
            CircleAvatar(
              child: Text(
                widget.coach.fullName.substring(0, 2).toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              radius: 20,
            ),
          const SizedBox(width: 12),
          Text(widget.coach.fullName),
        ],
      ),
    );
  }

  String _getFullImageUrl(String imageUrl) {
    if (imageUrl.startsWith('http')) return imageUrl;
    
    // Handle different photo URL formats
    if (imageUrl.startsWith('/uploads/')) {
      return '${_chatService.getBaseUrl()}$imageUrl';
    } else if (imageUrl.startsWith('/')) {
      return '${_chatService.getBaseUrl()}$imageUrl';
    } else {
      // If no leading slash, assume it's in uploads directory
      return '${_chatService.getBaseUrl()}/uploads/$imageUrl';
    }
  }

  Widget _buildImageWidget(types.ImageMessage message) {
    if (message.uri.startsWith('http')) {
      return Image.network(
        message.uri,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.4,
            color: Colors.grey[300],
            child: const Icon(Icons.error_outline, color: Colors.red),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.4,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    } else if (kIsWeb) {
      return Image.memory(
        localImageBytes[message.uri]!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.4,
            color: Colors.grey[300],
            child: const Icon(Icons.error_outline, color: Colors.red),
          );
        },
      );
    } else {
      return Image.file(
        File(message.uri),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.4,
            color: Colors.grey[300],
            child: const Icon(Icons.error_outline, color: Colors.red),
          );
        },
      );
    }
  }
}

// Custom image preview dialog
class ImagePreviewDialog extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewDialog({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          PhotoView(
            imageProvider: NetworkImage(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            backgroundDecoration: const BoxDecoration(
              color: Colors.transparent,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
