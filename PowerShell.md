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

## 優先度付き組み分け時に各パターンの HD, SD 確率を求める

地形 A > 地形 B > 地形 C > …… のように優先度による組み分けをする場合に、各地形についてハードドロップのみで組める確率とソフトドロップが必要になる確率を求めます。

すなわち、以下のような優先順位で組み分ける場合に、それぞれの確率を求めます

* 地形 A ハードドロップのみ
* 地形 A ソフトドロップあり
* 地形 B ハードドロップのみ
* 地形 B ソフトドロップあり
* 地形 C ハードドロップのみ
* 地形 C ソフトドロップあり
* ……

### サンプルコード

sfinder.jar があるディレクトリで以下のように実行してください。

```
using namespace System.Collections.Generic

# この行のみを変更すること
$input_fumens = 'v115@vhFxRJWNJUDJXLJNKJTJJ v115@vhF+MJTNJNLJqJJvKJJEJ v115@vhFyRJpIJsHJXLJNKJTJJ'


[list[string]]$fumens_list = $input_fumens.Split(' ')

java -jar sfinder.jar cover -t $input_fumens -p *p7 -d harddrop
$output_hd = Import-Csv -Path output/cover.csv

java -jar sfinder.jar cover -t $input_fumens -p *p7 -d softdrop
$output_sd = Import-Csv -Path output/cover.csv

$prob_list = @(0) * ($fumens_list.Count * 2)

$output_list = [list[string]]::new($output_hd.Count + 1)

$headder_text = 'sequence'

foreach($fumen in $fumens_list)
{
    $headder_text = $headder_text + ',[HD]' + $fumen + ',[SD]' + $fumen
}

$output_list.Add($headder_text)


foreach($i in (0..($output_hd.count - 1)))
{
    $append_text = $output_hd[$i].sequence
    
    foreach($fumen in $fumens_list)
    {
        $append_text = $append_text + ',' + $output_hd[$i].$fumen + ',' + $output_sd[$i].$fumen
    }
    
    
    $output_list.Add($append_text)
    
    $pattern_num = ($output_list[$i + 1].IndexOf('O',$output_hd[$i].sequence.Length) - $output_hd[$i].sequence.Length - 1) / 2

    if($pattern_num -ge 0)
    {
        $prob_list[$pattern_num]++
    }

}

$OR = 0
$AND = 0

$output_text = [list[string]]::new($fumens_list.Count * 2 + 5)
$output_text.Add('# Output')
$output_text.Add('success:')
foreach($i in (0..($fumens_list.Count - 1)))
{
    
    $output_text.Add([string]::Format('{0,0:#0.00} % [{1}/{2}]: [HD]http://fumen.zui.jp/?{3}', $prob_list[2 * $i + 0] / $output_hd.Count * 100, $prob_list[2 * $i + 0], $output_hd.Count, $fumens_list[$i]))
    $output_text.Add([string]::Format('{0,0:#0.00} % [{1}/{2}]: [SD]http://fumen.zui.jp/?{3}', $prob_list[2 * $i + 1] / $output_hd.Count * 100, $prob_list[2 * $i + 1], $output_hd.Count, $fumens_list[$i]))
    $OR = $OR + $prob_list[2 * $i + 0] + $prob_list[2 * $i + 1]
}
$output_text.Add('>>>')
$output_text.Add([string]::Format('OR  = {0,0:#0.00} % [{1}/{2}]', $OR / $output_hd.Count * 100, $OR, $output_hd.Count * 100))
$output_text.Add([string]::Format('AND = {0,0:#0.00} % [{1}/{2}]', $AND / $output_hd.Count * 100, $AND, $output_hd.Count * 100))

$output_list | Out-File output/cover.csv
$output_text | Out-File output/last_output.txt
Write-Output ''
Write-Output $output_text
```
