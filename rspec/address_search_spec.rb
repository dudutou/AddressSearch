require 'rspec'
require '../lib/address_search'

describe 'split_ngramを検証します' do

  it '複数の文字列に分割される場合' do
    service = AddressSearch.new
    result = service.split_ngram('東京都', 2)
    expect(result.length).to eq 2
  end

  it 'Ngramの指定値より文字列が短い場合' do
    service = AddressSearch.new
    result = service.split_ngram('東京都', 4)
    expect(result.length).to eq 1
    expect(result[0]).to eq '東京都'
  end
end

describe 'split_keywordを検証します' do

  it '渋谷の場合' do
    service = AddressSearch.new
    result = service.split_keyword('渋谷')
    expect(result.length).to eq 2
    expect(result[0]).to eq '渋'
    expect(result[1]).to eq '谷'
  end

  it '東京都の場合' do
    service = AddressSearch.new
    result = service.split_keyword('東京都')
    expect(result.length).to eq 2
    expect(result[0]).to eq '東京'
    expect(result[1]).to eq '京都'
  end
end