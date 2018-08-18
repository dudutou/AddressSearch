require './lib/address_search'

service = AddressSearch.new
service.storage_path = 'storage'

service.create_index_file