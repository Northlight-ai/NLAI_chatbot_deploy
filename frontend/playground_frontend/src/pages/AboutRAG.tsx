import { ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import ChatBubble from '@/components/ChatBubble';

const AboutRAG = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 via-white to-orange-100">
      <div className="container mx-auto px-4 py-8">
        {/* Back Button */}
        <button
          onClick={() => navigate('/')}
          className="flex items-center gap-2 text-orange-600 hover:text-orange-700 font-medium mb-8 transition-colors"
        >
          <ArrowLeft size={20} />
          Back to Home
        </button>

        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold bg-gradient-to-r from-orange-500 to-orange-700 bg-clip-text text-transparent mb-4">
            About North Light AI RAG Technology
          </h1>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            Understanding how our Retrieval-Augmented Generation system transforms your website into an intelligent knowledge base
          </p>
        </div>

        {/* Content */}
        <div className="max-w-4xl mx-auto space-y-8">
          {/* RAG Overview */}
          <div className="bg-white rounded-2xl p-8 shadow-lg">
            <h2 className="text-2xl font-bold text-gray-800 mb-4">What is RAG?</h2>
            <p className="text-gray-600 leading-relaxed mb-4">
              Retrieval-Augmented Generation (RAG) is an advanced AI architecture that combines the power of large language models 
              with your specific knowledge base. Instead of relying solely on pre-trained knowledge, RAG systems retrieve relevant 
              information from your data and use it to generate accurate, contextual responses.
            </p>
          </div>

          {/* How it Works */}
          <div className="bg-white rounded-2xl p-8 shadow-lg">
            <h2 className="text-2xl font-bold text-gray-800 mb-6">How North Light AI RAG Works</h2>
            <div className="grid md:grid-cols-2 gap-6">
              <div className="space-y-4">
                <div className="flex items-start gap-3">
                  <div className="w-8 h-8 bg-orange-500 text-white rounded-full flex items-center justify-center font-bold text-sm">1</div>
                  <div>
                    <h3 className="font-semibold text-gray-800">Website Crawling</h3>
                    <p className="text-gray-600 text-sm">Our system analyzes your website's sitemap and crawls all accessible pages to extract content.</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <div className="w-8 h-8 bg-orange-500 text-white rounded-full flex items-center justify-center font-bold text-sm">2</div>
                  <div>
                    <h3 className="font-semibold text-gray-800">Content Processing</h3>
                    <p className="text-gray-600 text-sm">Text content is processed, chunked, and converted into vector embeddings for efficient retrieval.</p>
                  </div>
                </div>
              </div>
              <div className="space-y-4">
                <div className="flex items-start gap-3">
                  <div className="w-8 h-8 bg-orange-500 text-white rounded-full flex items-center justify-center font-bold text-sm">3</div>
                  <div>
                    <h3 className="font-semibold text-gray-800">Supabase Storage</h3>
                    <p className="text-gray-600 text-sm">All processed information is stored in Supabase vector database for fast and accurate retrieval.</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <div className="w-8 h-8 bg-orange-500 text-white rounded-full flex items-center justify-center font-bold text-sm">4</div>
                  <div>
                    <h3 className="font-semibold text-gray-800">AI Response</h3>
                    <p className="text-gray-600 text-sm">When you ask questions, relevant context is retrieved and fed to OpenAI GPT-4 for accurate answers.</p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Technical Architecture */}
          <div className="bg-white rounded-2xl p-8 shadow-lg">
            <h2 className="text-2xl font-bold text-gray-800 mb-4">Technical Architecture</h2>
            <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
              <div className="text-center">
                <div className="w-16 h-16 bg-gradient-to-r from-blue-400 to-blue-600 rounded-lg flex items-center justify-center mx-auto mb-3">
                  <span className="text-white text-2xl">🕷️</span>
                </div>
                <h3 className="font-semibold text-gray-800">Web Scraping</h3>
                <p className="text-gray-600 text-sm">Automated sitemap analysis and content extraction from your website</p>
              </div>
              <div className="text-center">
                <div className="w-16 h-16 bg-gradient-to-r from-green-400 to-green-600 rounded-lg flex items-center justify-center mx-auto mb-3">
                  <span className="text-white text-2xl">🗄️</span>
                </div>
                <h3 className="font-semibold text-gray-800">Supabase Vector DB</h3>
                <p className="text-gray-600 text-sm">High-performance vector storage and similarity search capabilities</p>
              </div>
              <div className="text-center">
                <div className="w-16 h-16 bg-gradient-to-r from-indigo-400 to-indigo-600 rounded-lg flex items-center justify-center mx-auto mb-3">
                  <span className="text-white text-2xl">🔗</span>
                </div>
                <h3 className="font-semibold text-gray-800">LangChain</h3>
                <p className="text-gray-600 text-sm">Orchestrates the RAG pipeline with document loaders, text splitters, and vector stores</p>
              </div>
              <div className="text-center">
                <div className="w-16 h-16 bg-gradient-to-r from-purple-400 to-purple-600 rounded-lg flex items-center justify-center mx-auto mb-3">
                  <span className="text-white text-2xl">🤖</span>
                </div>
                <h3 className="font-semibold text-gray-800">OpenAI GPT-4</h3>
                <p className="text-gray-600 text-sm">Advanced language model for generating contextual responses</p>
              </div>
            </div>
          </div>

          {/* Benefits */}
          <div className="bg-white rounded-2xl p-8 shadow-lg">
            <h2 className="text-2xl font-bold text-gray-800 mb-4">Key Benefits</h2>
            <div className="grid md:grid-cols-2 gap-4">
              <div className="flex items-center gap-3">
                <div className="w-6 h-6 bg-green-500 rounded-full flex items-center justify-center">
                  <span className="text-white text-sm">✓</span>
                </div>
                <span className="text-gray-700">Always up-to-date with your latest content</span>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-6 h-6 bg-green-500 rounded-full flex items-center justify-center">
                  <span className="text-white text-sm">✓</span>
                </div>
                <span className="text-gray-700">Accurate answers based on your data</span>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-6 h-6 bg-green-500 rounded-full flex items-center justify-center">
                  <span className="text-white text-sm">✓</span>
                </div>
                <span className="text-gray-700">Fast response times</span>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-6 h-6 bg-green-500 rounded-full flex items-center justify-center">
                  <span className="text-white text-sm">✓</span>
                </div>
                <span className="text-gray-700">Scalable and reliable infrastructure</span>
              </div>
            </div>
          </div>
        </div>

        {/* Chat Bubble Component */}
        <ChatBubble />
      </div>
    </div>
  );
};

export default AboutRAG;
