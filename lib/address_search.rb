require 'open-uri'
require 'open_uri_redirections'
require 'fileutils'
require 'zip'
require 'csv'
require './lib/file_accessor'


# 住所検索を行うクラスです。
class AddressSearch
  attr_reader :storage_path

  attr_writer :storage_path

  # ファイルをダウンロードしてインデックスを作成します。
  def create_index_file
    accessor = FileAccessor.new
    csv_path = accessor.store_csv(storage_path)
    indicies = create_indicies(csv_path, 2)
    accessor.save_indicies(indicies, storage_path)
  end


  # 指定された文字列をNgramで分割します。
  def split_ngram(text, ngram)
    result = []
    if text.length < ngram
      result.push(text)
    else
      0.upto(text.length - ngram) do |index|
        result.push(text[index, ngram])
      end
    end
    result
  end


  # keywordを分割します。
  def split_keyword(keyword)
    result = []
    2.times do |index|
      result.push(keyword[index, keyword.length - 1])
    end
    result
  end

  private

  # hash形式のインデックス情報を生成します。
  def create_indicies(csv_path, ngram)
    indicies = {}
    line_number = 0
    CSV.foreach(csv_path, encoding: 'Shift_JIS:UTF-8') do |row|
      row.each do |cell|
        split_ngram(cell, ngram).each do |index_text|
          indicies.store(index_text, []) unless indicies.key?(index_text)
          indicies[index_text].push(line_number)
        end
      end
      line_number += 1
    end
    indicies
  end

end