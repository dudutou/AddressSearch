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

  attr_reader :accessor

  attr_writer :accessor

  def initialize(storage_path)
    @accessor = FileAccessor.new(storage_path)
    @storage_path = storage_path
  end

  # インデックスとファイルダウンロードが終わっているかチェックします
  # 存在しなければファイルダウンロードを行い、インデックスを取得します。
  def validate_file
    create_index_file unless @accessor.validate_file
  end

  # ファイルをダウンロードしてインデックスを作成します。
  def create_index_file
    puts 'ファイルをダウンロードします'
    csv_path = accessor.store_csv()
    puts 'インデックスを作成します'
    indicies = create_indicies(csv_path, 2)
    @accessor.save_indicies(indicies)
  end

  # インデックスを用いて検索を実施します。
  def search(keyword)
    keywords = split_keyword(keyword)
    indicies = load_indicies
    line_numbers = match_by_indicies(indicies, keywords)
    File.open(@accessor.build_csv_path, encoding: 'Shift_JIS:UTF-8') do |file|
      line_number = 0
      file.each_line do |line|
        puts line if line_numbers.include?(line_number)
        line_number += 1
      end
    end
  end
  
  # インデックスを読み込みます
  def load_indicies
    filename = @accessor.build_index_path
    indicies = {}
    CSV.foreach(filename) do |row|
      indicies.store(row[0], row[1..row.length - 1].map(&:to_i))
    end
    indicies
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

  def match_by_indicies(indicies, keywords)
    line_by_keyword = {}
    keywords.each do |item|
      hit = []
      indicies.each do |key, value|
        hit.concat(value) if key.include?(item)
      end
      line_by_keyword.store(item, []) unless line_by_keyword.key?(item)
      line_by_keyword[item].concat(hit.uniq)
    end
    line_numbers = line_by_keyword[keywords[0]]
    keywords[1..keywords.length - 1].each do |item|
      line_numbers &= line_by_keyword[item]
    end
    line_numbers
  end

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