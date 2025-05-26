

import ChatBubble from "@/components/ChatBubble";
import { useNavigate } from "react-router-dom";

const Index = () => {
  const navigate = useNavigate();

  const handleGetStarted = () => {
    navigate('/playground');
  };

  const handleLearnMore = () => {
    navigate('/about-rag');
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 via-white to-orange-100">
      {/* Hero Section */}
      <div className="container mx-auto px-4 py-16">
        <div className="text-center space-y-6">
          <img 
            src="/lovable-uploads/023abf7f-c0b5-4134-9f38-7e5fd5bfdc3f.png" 
            alt="North Light AI" 
            className="h-16 w-auto mx-auto mb-4"
          />
          
          {/* Title Box with Content */}
          <div className="bg-white rounded-2xl p-8 shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105 max-w-3xl mx-auto">
            <h1 className="text-5xl font-bold text-black mb-6">
              North Light AI Chatbot
            </h1>
            <p className="text-xl text-gray-600 mb-8">
              Experience the power of intelligent conversation with our advanced RAG-powered chatbot. 
              Connect, communicate, and get precise answers from your website data.
            </p>
            <div className="flex justify-center space-x-4">
              <button 
                onClick={handleGetStarted}
                className="bg-gradient-to-r from-orange-400 to-orange-600 text-white px-8 py-3 rounded-full font-semibold hover:shadow-lg transition-all duration-300 hover:scale-105"
              >
                Get Started
              </button>
              <button 
                onClick={handleLearnMore}
                className="border-2 border-gray-300 text-gray-700 px-8 py-3 rounded-full font-semibold hover:border-orange-500 hover:text-orange-500 transition-all duration-300"
              >
                Learn More
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Features Section */}
      <div className="container mx-auto px-4 py-16">
        <div className="grid md:grid-cols-3 gap-8">
          <div className="bg-white rounded-2xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105">
            <div className="w-12 h-12 bg-gradient-to-r from-orange-400 to-orange-600 rounded-lg flex items-center justify-center mb-4">
              <span className="text-white text-xl">🧠</span>
            </div>
            <h3 className="text-xl font-semibold mb-2 text-gray-800">RAG Technology</h3>
            <p className="text-gray-600">
              Advanced Retrieval-Augmented Generation powered by your website's content and OpenAI GPT-4.
            </p>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105">
            <div className="w-12 h-12 bg-gradient-to-r from-orange-400 to-orange-600 rounded-lg flex items-center justify-center mb-4">
              <span className="text-white text-xl">⚡</span>
            </div>
            <h3 className="text-xl font-semibold mb-2 text-gray-800">Lightning Fast</h3>
            <p className="text-gray-600">
              Get instant, accurate responses from your website data with intelligent context understanding.
            </p>
          </div>

          <div className="bg-white rounded-2xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105">
            <div className="w-12 h-12 bg-gradient-to-r from-orange-400 to-orange-600 rounded-lg flex items-center justify-center mb-4">
              <span className="text-white text-xl">🌟</span>
            </div>
            <h3 className="text-xl font-semibold mb-2 text-gray-800">Smart Integration</h3>
            <p className="text-gray-600">
              Seamlessly integrates with your website through sitemap analysis and Supabase storage.
            </p>
          </div>
        </div>
      </div>

      {/* Chat Bubble Component */}
      <ChatBubble />
    </div>
  );
};

export default Index;

