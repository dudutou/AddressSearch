require 'open-uri'
require 'open_uri_redirections'
require 'fileutils'
require 'zip'
require 'csv'

# ファイルの読み書きを扱うクラスです。
class FileAccessor
  attr_reader :storage_path

  attr_writer :storage_path

  def initialize(storage_path)
    @storage_path = storage_path
  end


  # zipファイルをダウンロードしてcsvファイルを取得します。
  def store_csv
    zip_folder = @storage_path + '/zip'
    filename = download_zip(zip_folder)
    csv_folder = build_csv_folder_path
    FileUtils.mkdir_p(csv_folder) unless FileTest.exist?(csv_folder)
    csv_path = extra_zip(filename, csv_folder)
    FileUtils.rm_r(zip_folder)
    csv_path
  end

  def validate_file
    File.exist?(build_csv_path) && File.exist?(build_index_path)
  end
  
  def build_csv_folder_path
    @storage_path + '/csv'
  end

  def build_csv_path
    Dir.glob(build_csv_folder_path + '/*.CSV').each do |file|
      return file
    end
  end

  # zipファイルを解凍します
  def extra_zip(path, output)
    Zip::File.open(path) do |zip|
      zip.each do |entry|
        path = output + '/' + entry.name
        zip.extract(entry, path) {true}
        return path
      end
    end
  end

  # インデックスを保存します。
  def save_indicies(indicies)
    index_name = build_index_path()
    CSV.open(index_name, 'w') do |csv|
      indicies.each do |key, values|
        row = [key]
        values.each do |value|
          row.push(value)
        end
        csv << row
      end
    end
  end
  # インデックスファイルのパスを取得します。
  def build_index_path
    index_name = @storage_path + '/indicies.csv'
    index_name
  end


  # ファイルをダウンロードして解凍します
  def download_zip(folder)
    url = 'http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip'
    filename = folder + '/ken_all.zip'
    FileUtils.mkdir_p(folder) unless FileTest.exist?(folder)
    open(url, allow_redirections: :all) do |file|
      open(filename, 'w+b') do |out|
        out.write(file.read)
      end
    end
    filename
  end

end