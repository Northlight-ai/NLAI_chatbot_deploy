
import React, { useState, useRef, useEffect } from 'react';
import { Send, ArrowLeft, MessageCircle } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { useToast } from '@/hooks/use-toast';
import { useNavigate } from 'react-router-dom';

interface Message {
  id: string;
  type: 'user' | 'bot';
  content: string;
  timestamp: Date;
}

const Playground = () => {
  const [messages, setMessages] = useState<Message[]>([]);
  const [inputValue, setInputValue] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const { toast } = useToast();
  const navigate = useNavigate();

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const handleSendMessage = async () => {
    if (!inputValue.trim()) return;

    const userMessage: Message = {
      id: Date.now().toString(),
      type: 'user',
      content: inputValue,
      timestamp: new Date(),
    };

    setMessages(prev => [...prev, userMessage]);
    const currentInput = inputValue;
    setInputValue('');
    setIsLoading(true);

    try {
      const encodedQuery = encodeURIComponent(currentInput);
      const url = `http://localhost:10000/chat?query=${encodedQuery}`;

      console.log('Sending request to:', url);

      const response = await fetch(url, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      console.log('Response status:', response.status);
      console.log('Response ok:', response.ok);

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      console.log('Response data:', data);

      const botMessage: Message = {
        id: (Date.now() + 1).toString(),
        type: 'bot',
        content: data.answer,
        timestamp: new Date(),
      };

      setMessages(prev => [...prev, botMessage]);
    } catch (error) {
      console.error('Detailed error:', error);

      let errorMessage = "Failed to send message.";

      if (error instanceof TypeError && error.message.includes('Failed to fetch')) {
        errorMessage = "Cannot connect to localhost from HTTPS. Try running the app locally or use a tunnel service like ngrok.";
      } else if (error instanceof Error) {
        errorMessage = `Error: ${error.message}`;
      }

      toast({
        title: "Connection Error",
        description: errorMessage,
        variant: "destructive",
      });

      const errorBotMessage: Message = {
        id: (Date.now() + 1).toString(),
        type: 'bot',
        content: "Sorry, I'm having trouble connecting to the backend. Please check the console for details.",
        timestamp: new Date(),
      };

      setMessages(prev => [...prev, errorBotMessage]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-100 via-orange-200 to-orange-300 flex items-center justify-center p-4">
      <div className="w-full max-w-4xl h-[90vh] bg-white/80 backdrop-blur-lg border border-white/20 rounded-3xl shadow-2xl overflow-hidden">
        {/* Header */}
        <div className="bg-gradient-to-r from-orange-400 to-orange-600 p-6 text-white">
          <div className="flex items-center justify-between">
            <button
              onClick={() => navigate('/')}
              className="flex items-center gap-2 text-orange-100 hover:text-white font-medium transition-colors"
            >
              <ArrowLeft size={20} />
              Back to Home
            </button>
            <div className="flex items-center gap-3">
              <div className="p-2 bg-white/20 rounded-full">
                <MessageCircle size={24} />
              </div>
              <div>
                <h1 className="text-2xl font-bold">North Light AI Playground</h1>
                <p className="text-orange-100 text-sm">Your intelligent assistant</p>
              </div>
            </div>
            <div className="w-24"></div>
          </div>
        </div>

        {/* Chat Messages */}
        <div className="flex-1 overflow-y-auto p-6 space-y-4 max-h-[calc(90vh-200px)]">
          {messages.length === 0 && (
            <div className="text-center text-gray-500 mt-20">
              <MessageCircle size={48} className="mx-auto mb-4 text-gray-300" />
              <p className="text-lg font-medium">Welcome! Ask me anything.</p>
              <p className="text-sm">Start a conversation by typing your question below.</p>
            </div>
          )}

          {messages.map((message) => (
            <div
              key={message.id}
              className={`flex ${message.type === 'user' ? 'justify-end' : 'justify-start'} animate-in slide-in-from-bottom-2 duration-300`}
            >
              <div
                className={`max-w-[80%] p-4 rounded-2xl ${message.type === 'user'
                  ? 'bg-gradient-to-r from-blue-500 to-blue-700 text-white'
                  : 'bg-gray-100 text-gray-800 border border-gray-200'
                  }`}
              >
                <p className="whitespace-pre-wrap break-words">{message.content}</p>
                <p className={`text-xs mt-2 ${message.type === 'user' ? 'text-blue-100' : 'text-gray-500'
                  }`}>
                  {message.timestamp.toLocaleTimeString()}
                </p>
              </div>
            </div>
          ))}

          {isLoading && (
            <div className="flex justify-start animate-in slide-in-from-bottom-2 duration-300">
              <div className="bg-gray-100 text-gray-800 border border-gray-200 p-4 rounded-2xl">
                <div className="flex items-center gap-2">
                  <div className="flex gap-1">
                    <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
                    <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: '0.1s' }}></div>
                    <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: '0.2s' }}></div>
                  </div>
                  <span className="text-sm text-gray-500">Thinking...</span>
                </div>
              </div>
            </div>
          )}

          <div ref={messagesEndRef} />
        </div>

        {/* Input Area */}
        <div className="p-6 bg-white/50 border-t border-gray-200/50">
          <div className="flex gap-3">
            <Input
              value={inputValue}
              onChange={(e) => setInputValue(e.target.value)}
              onKeyPress={handleKeyPress}
              placeholder="Type your question here..."
              className="flex-1 px-4 py-3 text-lg border-2 border-gray-200 rounded-xl focus:border-orange-500 focus:ring-0 bg-white/80"
              disabled={isLoading}
            />
            <Button
              onClick={handleSendMessage}
              disabled={!inputValue.trim() || isLoading}
              className="px-6 py-3 bg-gradient-to-r from-orange-400 to-orange-600 hover:from-orange-500 hover:to-orange-700 text-white rounded-xl transition-all duration-200 shadow-lg hover:shadow-xl"
            >
              <Send size={20} />
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Playground;
