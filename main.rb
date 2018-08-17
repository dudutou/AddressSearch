require './lib/address_search'

service = AddressSearch.new
service.storage_path = "storage"

# csvをダウンロード
service.download_file
