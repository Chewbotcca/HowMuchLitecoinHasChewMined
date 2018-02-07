# Require Gems needed to run programs and plugins
require './requiregems.rb'

# Load config from file
begin
  CONFIG = YAML.load_file('config.yaml')
rescue StandardError
  puts 'Config file not found, this is fatal.'
  exit
end

# Require each plugin
Dir["#{File.dirname(__FILE__)}/plugins/*.rb"].each { |file| require file }

# Pre-Config
botnick = "HowMuchLitecoinHas#{CONFIG['miner']}Mined"

botserver = if CONFIG['server'] == '' || CONFIG['server'].nil?
              puts 'You did not configure a server for the bot to connect to. Please set one!'
              exit
            else
              CONFIG['server'].to_s
            end

botport = if CONFIG['port'].nil?
            '6667'
          else
            CONFIG['port']
          end

commits = `git rev-list master | wc -l`.to_i
commit = if commits.zero?
           ''
         else
           " | Version: #{commits}"
         end

botrealname = "HowMuchLitecoinHasChewMined Bot - https://github.com/Chewbotcca/HowMuchLitecoinHasChewMined#{commit}"

botssl = if CONFIG['ssl'].nil? || CONFIG['ssl'] == '' || CONFIG['ssl'] == 'false' || CONFIG['ssl'] == false
           nil
         else
           'true'
         end

botserverpass = if CONFIG['serverpass'].nil? || CONFIG['serverpass'] == ''
                  nil
                else
                  CONFIG['serverpass']
                end

# Configure the Bot
bot = Cinch::Bot.new do
  configure do |c|
    # Bot Settings, Taken from pre-config
    c.nick = botnick
    c.server = botserver
    c.channels = [CONFIG['channels']]
    c.port = botport
    c.realname = botrealname
    c.messages_per_second = 5
    c.ssl.use = botssl
    c.password = botserverpass
    c.plugins.prefix = //

    c.plugins.plugins = [Main, NickServ]
  end
end

bot.start
