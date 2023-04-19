require 'http'
require 'json'
require 'dotenv'

Dotenv.load

def converse_with_ai(api_key, conversation_history)
  url = "https://api.openai.com/v1/engines/text-davinci-002/completions"
  headers = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{api_key}"
  }

  # Création du prompt en utilisant l'historique de conversation s'il existe
  if conversation_history.empty?
    prompt = "Bonjour, que puis-je faire pour vous aujourd'hui ?"
  else
    prompt = conversation_history.join("\n") + "\n"
  end

  # Envoi des informations à l'API OpenAI
  data = {
    "prompt" => prompt,
    "max_tokens" => 100,
    "temperature" => 0.5
  }
  response = HTTP.post(url, headers: headers, body: data.to_json)
  response_body = JSON.parse(response.body.to_s)
  response_string = response_body['choices'][0]['text'].strip

  # Ajout de la réponse à l'historique de conversation
  conversation_history << response_string

  # Affichage de la réponse
  puts "AI: #{response_string}"
end

# Début de la conversation
api_key = ENV["OPENAI_API_KEY"]
conversation_history = []

puts "Bonjour, je suis votre chatbot personnel. Comment puis-je vous aider ?"

loop do
  print "Vous: "
  user_input = gets.chomp

  # Si l'utilisateur dit "stop", on termine la conversation
  break if user_input.downcase == "stop"

  # Ajout de la réponse de l'utilisateur à l'historique de conversation
  conversation_history << "Vous: #{user_input}"

  # Appel de la méthode pour répondre à l'utilisateur
  converse_with_ai(api_key, conversation_history)
end

puts "Au revoir !"
