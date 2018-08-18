# AddressSearch

https://github.com/rimever/NgramIndex

上記の課題に対して、Rubyで挑戦したものです。

## 実行方法

>ruby main.rb {検索文字列}

+ main.rbに検索キーワードを起動引数に渡してください
+ csvファイルとインデックスが見つからない場合は、インデックスが作成されます

## 課題

+ Indexのアルゴリズム：N-Gram(N=２)

下記2つの機能を有するアプリケーション
※コンソールアプリケーションまたはウェブアプリケーションのどちらも構わない。

+ 郵便番号のCSV (http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip)をデータソースとし、住所レコードのインデックスファイルを作成する機能

+ 入力として、文字列が与えられる。与えられた文字列中の文字をすべて含む住所レコードを上記で作成したインデックスを用いて検索し出力する機能。ただしスペースは文字として扱わない。

### 例１:　入力: 渋谷

出力
"9870113","宮城県","遠田郡涌谷町","渋江"

"0101642","秋田県","秋田市","新屋渋谷町"

"6050874","京都府","京都市東山区","常盤町（東大路通渋谷上る、渋谷通東大路東入、渋谷通東大路東入２丁目、東大路五条下る）"

・・・・
#### 注意

下記のような一つのレコードが複数行に分かれている箇所が存在する。これについては別のレコードとして処理してもよいが、結合できることが望ましい。
26105,"605  ","6050874","ｷﾖｳﾄﾌ","ｷﾖｳﾄｼﾋｶﾞｼﾔﾏｸ","ﾄｷﾜﾁﾖｳ","京都府","京都市東山区","常盤町（東大路通渋谷上る、渋谷通東大路東入、渋谷通東大路東入２丁目、",0,0,0,0,0,0
26105,"605  ","6050874","ｷﾖｳﾄﾌ","ｷﾖｳﾄｼﾋｶﾞｼﾔﾏｸ","ﾄｷﾜﾁﾖｳ","京都府","京都市東山区","東大路五条下る）",0,0,0,0,0,0

### 例２：東京都

東京と京都が含まれている住所レコードが出力されること

