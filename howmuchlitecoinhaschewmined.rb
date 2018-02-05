require 'cinch'
require 'rest-client'
require 'json'
require 'YAML'

CONFIG = YAML.load_file('config.yaml')

class NickServ
  include Cinch::Plugin

  listen_to :connect, method: :identify

  def identify(_m)
    User('NickServ').send("identify #{CONFIG['nickserv']}")
  end
end

class Main
  include Cinch::Plugin

  match /HowMuchLitecoinHasChewMined/, method: :HowMuchLitecoinHasChewMined

  def HowMuchLitecoinHasChewMined(m)
    api = JSON.parse(RestClient.get("https://www.litecoinpool.org/api?api_key=#{CONFIG['api']}"))
    earned = api['user']['total_rewards']
    hashes = api['user']['total_work']
    price = api['market']['ltc_usd']
    m.reply "Chew has mined $#{earned * price} worth of Litecoin. (LTC: $#{price}) (Mined: #{earned}) (Hashes Solved: #{hashes})"
  end
end

# Configure the Bot
bot = Cinch::Bot.new do
  configure do |c|
    c.nick = 'HowMuchLitecoinHasChewMined'
    c.server = 'kitty.chew.chat'
    c.channels = ['#lobby,#anarchy,#chewsmemechamber']
    c.port = '6697'
    c.user = 'Litecoins'
    c.realname = 'oh snap'
    c.messages_per_second = 5
    c.ssl.use = true
    c.plugins.prefix = //

    c.plugins.plugins = [Main, NickServ]
  end
end

bot.start
