require 'open-uri'
require 'open_uri_redirections'
require 'fileutils'
require 'zip'
require 'csv'

class AddressSearch
  def storage_path
    @storagePath
  end

  def storage_path=(storage_path)
    @storagePath = storage_path
  end
  # ファイルをダウンロードして解凍します
  def download_file
    url = 'http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip'
    folder = storage_path + "/zip"
    filename = folder + "/ken_all.zip"
    FileUtils.mkdir_p(folder) unless FileTest.exist?(folder)
    open(url, :allow_redirections => :all) do |file|
      open(filename, "w+b") do |out|
        out.write(file.read)
      end
    end
    csvFolder = storage_path + "/csv"
    FileUtils.mkdir_p(csvFolder) unless FileTest.exist?(csvFolder)
    csv_path = extra_zip(filename, csvFolder)
    FileUtils.rm_r(folder)

    indicies = {}
    line_number = 0
    CSV.foreach(csv_path, encoding: "Shift_JIS:UTF-8")  do |row|
      row.each do |cell|
        parse_ngram(cell, 2).each do |index_text|
          if indicies.has_key?(index_text) == false
            indicies.store(index_text,[])
          end
          indicies[index_text].push(line_number)
        end
      end
      line_number = line_number + 1
    end
    index_name = storage_path + "/indicies.csv"
    CSV.open(index_name, "w") do |csv|
      indicies.each do |key,values|
        row = [key]
        values.each do |value|
          row.push(value)
        end
        csv << row
      end
    end
  end

  def parse_ngram(text, ngram)
    result = []
    if (text.length < ngram)
      result.push(text)
    else
      0.upto(text.length - ngram) do |index|
        result.push(text[index,ngram])
      end
    end
    return result
  end

  # zipファイルを解凍します
  def extra_zip(path,output)
    Zip::File.open(path) do |zip|
      zip.each do |entry|
        path = output + "/" + entry.name
        zip.extract(entry,path) { true }
        return path
      end
    end
  end
end