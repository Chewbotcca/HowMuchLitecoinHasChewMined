class Main
  include Cinch::Plugin

  match /HowMuchLitecoinHas#{CONFIG['miner']}Mined/, method: :checkstats

  def checkstats(m)
    api = JSON.parse(RestClient.get("https://www.litecoinpool.org/api?api_key=#{CONFIG['api']}"))
    earned = api['user']['total_rewards']
    hashes = api['user']['total_work']
    price = api['market']['ltc_usd']
    if CONFIG['otherinvoke'] || CONFIG['otherinvoke'] == false && CONFIG['miner'] == m.user.name
      m.reply "#{CONFIG['miner']} has mined $#{earned * price} worth of Litecoin. (LTC: $#{price}) (Mined: #{earned}) (Hashes Solved: #{hashes})"
    end
  end
end
