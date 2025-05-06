import { io } from 'socket.io-client';

// Connect to the WebSocket server
const socket = io('http://localhost:3000'); // Change the port if needed

// Generate a random user ID for testing
const userId = Math.floor(Math.random() * 1000).toString();

socket.on('connect', () => {
  console.log(`Connected to WebSocket server (User ID: ${userId})`);

  // Join a test conversation
  socket.emit('joinConversation', {
    conversationId: 123
  });
  console.log('Joined conversation 123');

  // Send a test message
  const testMessage = {
    senderId: userId,
    conversationId: 123,
    content: `Hello from user ${userId}!`
  };
  
  socket.emit('sendMessage', testMessage);
  console.log('Sent message:', testMessage);
});

socket.on('newMessage', (message) => {
  console.log('\nReceived new message:', message);
});

socket.on('userTyping', (data) => {
  console.log(`\nUser ${data.userId} is typing...`);
});

socket.on('messagesRead', (data) => {
  console.log(`\nMessages read by user ${data.userId}`);
});

socket.on('connect_error', (error) => {
  console.error('WebSocket connection error:', error);
});

socket.on('disconnect', () => {
  console.log('WebSocket connection closed');
});