load 'retweetbot.rb'
#require 'twitter'

def main
  runBot = Retweetbot.new
  runBot.bot(200)
  sleep(60)
  loop do

    runBot.bot(20)
    sleep(30)

  end

end

run(main)
