require 'twitter'


class Retweetbot

	attr_reader :t
	@@comptes = ["CNIL","LINCnil","virtualegis","actecil","PrivaticsInria","privacytechlaw","DPO_News"]
	@@client = Twitter::REST::Client.new do |config|
			config.consumer_key					= 
			config.consumer_secret     	= 
	  	config.access_token        	= "2401933712-8tOFfsX5XtLRl0i7BVbhxO66Zv1sg536XanJQKU"
	  	config.access_token_secret 	= "Avm8woRmQeujdRnlrEJY7IZlheL9XMvQuysigpc8SMFGF"
	end

	#Retourne le temps en seconde entre le tweet choisi et l'heure actuelle
	def calculDifTemps(tweet)

		return @t - tweet.created_at

	end

	#Retourne le nombre d'heures dans le temps en seconde passer en paramètre
	def nombreHeure(temps)

		return (temps/3600).truncate(0)

	end

	#Retourne le nombre de jours dans le temps en seconde passer en paramètre
	def nombreJour(temps)

		return (temps/3600/24).truncate(0)

	end

 #Récupère les x derniers tweets de comptes twitter définis par la liste contenue dans la variable comptes
 #La variable nbreTweetRecup définie le nombre de tweets à récupérer
	def bot (nbreTweetRecup)
		@@comptes.each do |compte|

			@t = Time.new.getlocal("+00:00")
			tweets = @@client.user_timeline(compte, count: nbreTweetRecup)


			tweets.each do |tweet|
				if tweet.user_mentions.length == 0																								#S'assure que ce n'est pas un retweet
					difTemps = calculDifTemps(tweet)
					nbreJours = nombreJour(difTemps)
					nbreHeures = nombreHeure(difTemps)
					if (nbreJours == 0 && nbreHeures > 0)
						begin
							@@client.retweet!(tweet)
							puts "RT : nbre d'heures : #{nbreHeures}  temps : #{difTemps}"
						rescue
							puts "déjà RT"
						end
					elsif nbreJours < 16 && nbreJours > 0
						begin
							@@client.retweet!(tweet)
							puts "RT2 : nbre d'heures : #{nbreHeures}  temps : #{difTemps}"
						rescue
							puts "déjà RT2"
						end
					else
	 					puts nbreJours
					end
				end
			end
		end
	end

end
