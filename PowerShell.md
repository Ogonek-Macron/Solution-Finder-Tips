# PowerShell を使った Solution-Finder 活用法

## 使用ミノ別のパフェ率を表示する

実際に使うミノ別のパフェ率を表示する方法です。

なお、「使用ミノごとの確率」なので、そのまま「残すミノごとの確率」も分かります。

例えば、ミノ順が `*p7` で 6 ミノを使用してパフェを取る場合、「O ミノを残してパフェが取れる確率」=「TIJLSZ ミノを使用してパフェが取れる確率」です。

### サンプルコード

sfinder.jar があるディレクトリで以下のように実行してください。

```
#この 2 行を必要に応じて書き換える
$pattern = '[IJLOSTZ]p7'
java -jar sfinder.jar path -t v115@zgA8GeC8GeE8EeD8DeG8AeF8JeAgH -P 1 -c 5 -p $pattern -f csv -k use

#以下は書き換えない
$denominator = (java -jar sfinder.jar util seq -p $pattern).Count
Import-Csv output\path.csv | % {''} {$numerator = $_.'対応ツモ数 (対パターン)'; '{0} -> {1:0.00} % [{2}/{3}]' -f $_.'使用ミノ', ($numerator / $denominator * 100), $numerator, $denominator}
```
