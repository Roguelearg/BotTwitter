require 'twitter'



client = Twitter::REST::Client.new do |config|
	config.consumer_key			= "hmSD6z6I2qk5EvZYjlWq7xPEk"
	config.consumer_secret     	= "BDpiSEvrPpWfShukwXkPW6SkXnZO40j49JVE4gXri12p9Z2dOF"
		config.access_token        	= "2401933712-8tOFfsX5XtLRl0i7BVbhxO66Zv1sg536XanJQKU"
		config.access_token_secret 	= "Avm8woRmQeujdRnlrEJY7IZlheL9XMvQuysigpc8SMFGF"
	end

streamer = Twitter::Streaming::Client.new do |config|
	config.consumer_key			= "hmSD6z6I2qk5EvZYjlWq7xPEk"
	config.consumer_secret     	= "BDpiSEvrPpWfShukwXkPW6SkXnZO40j49JVE4gXri12p9Z2dOF"
  	config.access_token        	= "2401933712-8tOFfsX5XtLRl0i7BVbhxO66Zv1sg536XanJQKU"
  	config.access_token_secret 	= "Avm8woRmQeujdRnlrEJY7IZlheL9XMvQuysigpc8SMFGF"
end


t = Time.new.getlocal("+00:00")

tweets = client.user_timeline("CNIL", count: 1)
tweets.each { |tweet| puts "#{tweet.attrs}"}



class Retweetbot

	attr_reader :t
	@@comptes = ["CNIL","LINCnil","virtualegis","actecil","PrivaticsInria","privacytechlaw","DPO_News"]
	@@client = Twitter::REST::Client.new do |config|
		config.consumer_key			= "hmSD6z6I2qk5EvZYjlWq7xPEk"
		config.consumer_secret     	= "BDpiSEvrPpWfShukwXkPW6SkXnZO40j49JVE4gXri12p9Z2dOF"
	  	config.access_token        	= "2401933712-8tOFfsX5XtLRl0i7BVbhxO66Zv1sg536XanJQKU"
	  	config.access_token_secret 	= "Avm8woRmQeujdRnlrEJY7IZlheL9XMvQuysigpc8SMFGF"
	end

	#retourne le temps en seconde entre le tweet choisi et l'heure actuelle
	def calculDifTemps(tweet)

		return @t - tweet.created_at

	end

	#retourne le nombre d'heures dans le temps en seconde passer en paramètre
	def nombreHeure(temps)

		return (temps/3600).truncate(0)

	end

	#retourne le nombre de jours dans le temps en seconde passer en paramètre
	def nombreJour(temps)

		return (temps/3600/24).truncate(0)

	end

	def bot (nbreTweetRecup)
		@@comptes.each do |compte|

			@t = Time.new.getlocal("+00:00")
			tweets = @@client.user_timeline(compte, count: nbreTweetRecup)


			tweets.each do |tweet|
				if !tweet.retweeted?
					difTemps = calculDifTemps(tweet)
					nbreJours = nombreJour(difTemps)
					nbreHeures = nombreHeure(difTemps)
					if ((nbreJours == 0 && nbreHeures > 0) || nbreJours < 16)
						begin
							@@client.retweet!(tweet)
							puts "RT"
						rescue
							puts "déjà RT"
						end
					else
						puts nbreJours
					end
				end
			end
		end
	end

end

