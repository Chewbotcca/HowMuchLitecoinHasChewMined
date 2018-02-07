begin
  require 'cinch'
rescue LoadError
  puts "You're missing the gem `cinch`. Would you like to install this now? (y/n)"
  input = gets.chomp
  if input == 'y'
    `gem install cinch`
    puts 'Gem installed! Continuing..'
  else
    puts 'To continue, install the cinch gem'
    exit
  end
end
begin
  require 'restclient'
rescue LoadError
  puts "You're missing the gem `rest-client`. Would you like to install this now? (y/n)"
  input = gets.chomp
  if input == 'y'
    `gem install rest-client`
    puts 'Gem installed! Continuing..'
  else
    puts 'To continue, install the rest-client gem'
    exit
  end
end
require 'json'
require 'yaml'
