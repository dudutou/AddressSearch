require 'rspec'
require '../lib/address_search'

describe 'parse_ngramを検証します' do

  it '複数の文字列に分割される場合' do
    service = AddressSearch.new
    result = service.parse_ngram("東京都",2)
    expect(result.length).to eq 2
  end

  it 'Ngramの指定値より文字列が短い場合' do
    service = AddressSearch.new
    result = service.parse_ngram("東京都",4)
    expect(result.length).to eq 1
    expect(result[0]).to eq "東京都"
  end
end