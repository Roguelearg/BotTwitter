
require 'rubygems'
require 'Twitter'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

client = Twitter::REST::Client.new do |config|
	config.consumer_key			= "qfQcGb8nfhQ6FKruQ5htiCThU"
	config.consumer_secret     	= "D6FWoprA2ZLatP3jmFd2m2VWNmJijyWPOpalmlgMgfrZMbyAWR"
  	config.access_token        	= "2401933712-8tOFfsX5XtLRl0i7BVbhxO66Zv1sg536XanJQKU"
  	config.access_token_secret 	= "Avm8woRmQeujdRnlrEJY7IZlheL9XMvQuysigpc8SMFGF"
end
test = client.followers
 test.each{|name| puts"#{name.screen_name}"}
#Methode principale du programme
#Prend un client, identifie l'id du dernier message afin de ne pas spammer l'expediteur en retour, et tout nouveau message direct reçu pendant que le programme est lancer aura sa reponse automatique
#Manque juste la vérification si la personne nous follow afin de pouvoir repondre au message
def run(client)
	dernierMessage = client.direct_messages_received().first.id
	while true
		reponse = client.direct_messages_received()
		puts "reponse #{reponse.first.id}"
		if reponse.first.id != dernierMessage
			client.create_direct_message(reponse.first.sender.screen_name, 'Trop cool ça fonctionne !')
			dernierMessage = client.direct_messages_received().first.id
		end
		sleep(10)
	end
end

run(client)




