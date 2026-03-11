RubyLLM.configure do |config|
  config.openai_api_key = ENV["OPENAI_API_KEY"]
end

git add config/initializers/ruby_llm.rb
git commit -m "Setup ruby_llm gem"
