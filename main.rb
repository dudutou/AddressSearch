require './lib/address_search'

service = AddressSearch.new('storage')
service.validate_file
if ARGV.length == 0
  puts '検索する文字列を指定してください'
else
  service.search(ARGV[0])
end

