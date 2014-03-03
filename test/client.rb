require 'bundler/setup'
$:.unshift File.expand_path('../../lib', __FILE__)
require 'purls'

MAXTIME = 30

urls = [
  'https://www.google.ca/',
  'https://www.facebook.com/',
  'https://twitter.com/',
  'http://www.pressly.com/',
  'http://nulayer.com/',
  'http://nulayer.com/',
  'http://nulayer.com/images/logo.png?x=http%3A%2F%2Fblah.com',
  # 'http://localhost:4567/',
  'http://faasdfasfdf23f23f23fwfasdf.com'
]

Purls.service_uri = 'http://localhost:9333'
Purls.maxtime = MAXTIME

obj = Purls.get(urls)#, { maxtime: MAXTIME })
puts obj.inspect

# puts
# puts

# puts "Sleeping for 5... then doing it again.."
# sleep 5

# obj = Purls.get(urls)#, { maxtime: MAXTIME })
# puts obj.inspect
