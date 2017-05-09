require 'twitter'



class Retweetbot

	attr_reader :t
	@@comptes = ["CNIL","LINCnil","virtualegis","actecil","PrivaticsInria","privacytechlaw","DPO_News"]
	@@client = Twitter::REST::Client.new do |config|
			config.consumer_key					=
			config.consumer_secret     	=
	  	config.access_token        	=
	  	config.access_token_secret 	= 
	end

	#Retourne le temps en seconde entre le tweet choisi et l'heure actuelle
	def calculDifTemps(tweet)

		return @t - tweet.created_at

	end

	#Retourne le nombre de minutes dans le temps en seconde passer en paramètre
	def nombreMinutes(temps)

		return (temps/60).truncate(0)

	end


	#Retourne le nombre d'heures dans le temps en seconde passer en paramètre
	def nombreHeure(temps)

		return (temps/3600).truncate(0)

	end

	#Retourne le nombre de jours dans le temps en seconde passer en paramètre
	def nombreJour(temps)

		return (temps/3600/24).truncate(0)

	end

	def recuperationURLs(tweet)
		tweet.urls.each do |url|
			puts "#{url.expanded_url}"
		end
	end

	def recuperationHashtags(tweet)
		tweet.hashtags.each do |hashtag|
			puts "#{hashtag.text}"
		end
	end


 #Récupère les x derniers tweets de comptes twitter définis par la liste contenue dans la variable comptes
 #La variable nbreTweetRecup définie le nombre de tweets à récupérer
	def bot (nbreTweetRecup)
		@@comptes.each do |compte|

			@t = Time.new.getlocal("+00:00")
			tweets = @@client.user_timeline(compte, count: nbreTweetRecup)


			tweets.each do |tweet|
				if ((tweet.in_reply_to_screen_name == "virtualegis" || tweet.in_reply_to_screen_name.nil?) && tweet.text[0, 2] != "RT" )																				#S'assure que ce n'est pas un retweet
					difTemps = calculDifTemps(tweet)
					nbreJours = nombreJour(difTemps)
					nbreHeures = nombreHeure(difTemps)
					if (nbreJours == 0 && nbreHeures > 0)
						begin
							@@client.retweet!(tweet)
							puts "RT : nombre d'heures : #{nbreHeures}  auteur : #{compte}"
						rescue
							puts "déjà RT  auteur : #{compte}"
						end
					elsif nbreJours < 16 && nbreJours > 0
						begin
							@@client.retweet!(tweet)
							puts "RT2 : nombre de jours : #{nbreJours}  auteur : #{compte}"
						rescue
							puts "déjà RT2  auteur : #{compte}"
						end
					elsif nbreJours > 0
	 					puts "nombre de jours : #{nbreJours}  auteur : #{compte}"
					elsif nbreJours == 0
						puts "nombre de minutes : #{nombreMinutes(difTemps)}  auteur : #{compte}"
					end
				end
			end
		end
	end

end
