#開幕 TD アタック 2 巡目探索プログラム
#Ver 0.1
#
#14 手目に TST をするパターンのうち、TD 屋根以外に hole が無く、8 段パフェがあるものを列挙

#Solution-Finder と同じディレクトリで実行すること

#ここで EFL のファイルを実行すること
#ダウンロードは以下から
#https://github.com/Ogonek-Macron/Edit-Fumen-Library-for-PowerShell/blob/main/Edit-Fumen-Lib.ps1


#ここから引数指定
#必要に応じて変更すること

#入力するテト譜とページ数を指定
$Tetfu = 'v115@9gQ4HewhR4DewwBewhg0Q4AeBtxwRpwhi0AeBtwwRp?whJeAgH'
$Page = 1

#TD アタック部分最下段の穴の位置を指定
#最も左の列が 0
$hole_column = 3

#屋根がどちら側か指定 ('left' or 'right')
#省略して 'l' or 'r' などでもでもよい
$Roof = 'left'



#以下のコードは変更しなくてよい

#左側屋根でコードを書いているので、右側屋根ならば入力テト譜の左右を反転
if ($Roof.Substring(0, 1) -eq 'r')
{
    $Tetfu = Mirror-Pages $Tetfu
    $hole_column = 9 - $hole_column
}

$Source = (EditFumen_RawToTable $Tetfu)[$Page - 1]

#$Source.field_current


$pieces_counter = [List[int]]::new([int[]]@(0) * 9)


#ブロック数のカウント
switch ($Source.field_current.GetRange(150, 80))
{
    default
    {
        #
        $pieces_counter[$_]++
    }
}

#setup に入力する patterns を決定
if($pieces_counter[0] -eq 52)
{
    $patterns = '[^T]!'
    $need_pieces = 6
}
else
{
    $patterns = '_ILOZTJSX'.Substring($pieces_counter.IndexOf(0, 1, 7), 1) + ',[^T]!'
    $need_pieces = 7
}

#setup の仕様のために埋めておく座標
$Source.field_current[$hole_column + 179] = 2

#I または X で塗りつぶす
$cyan_index = [hashset[Int]]::new(80)
$cyan_index.UnionWith([Int[]](190..229))
[void]$cyan_index.Remove($hole_column + 189)
[void]$cyan_index.Remove($hole_column + 199)
[void]$cyan_index.Remove($hole_column + 200)
[void]$cyan_index.Remove($hole_column + 209)
[void]$cyan_index.Remove($hole_column + 220)
[void]$cyan_index.Add($hole_column + 168)
[void]$cyan_index.Add($hole_column + 169)
[void]$cyan_index.Add($hole_column + 178)

switch ($cyan_index)
{
    default
    {
        if($Source.field_current[$_] -eq 0)
        {
            $Source.field_current[$_] = 1
        }
        else
        {
            $Source.field_current[$_] = 8
        }
    }
}

#O または X で塗りつぶす
$yellow_index = [hashset[Int]]::new(80)

[void]$yellow_index.Add($hole_column + 148)
[void]$yellow_index.Add($hole_column + 149)
[void]$yellow_index.Add($hole_column + 158)
[void]$yellow_index.Add($hole_column + 159)

if($hole_column -ge 3)
{
    switch(0..($hole_column - 3))
    {
        default
        {
            $yellow_index.UnionWith([int[]]((150 + $_), (160 + $_), (170 + $_), (180 + $_)))
        }
    }
}

if($hole_column -le 5)
{
    [void]$yellow_index.Add($hole_column + 164)
    [void]$yellow_index.Add($hole_column + 174)
    [void]$yellow_index.Add($hole_column + 184)
}

if($hole_column -le 6)
{
    switch(($hole_column + 5)..9)
    {
        default
        {
            $yellow_index.UnionWith([int[]]((150 + $_), (160 + $_), (170 + $_), (180 + $_)))
        }
    }
}

switch ($yellow_index)
{
    default
    {
        if($Source.field_current[$_] -eq 0)
        {
            $Source.field_current[$_] = 3
        }
        else
        {
            $Source.field_current[$_] = 8
        }
    }
}

#バグ回避のための処理
$source_raw = (EditFumen_TableToRaw $source)
$source_table = EditFumen_RawToTable ((Concat-Fumen (@($source_raw) * 6)))

#1 ページ目

#I または X で塗りつぶす
$cyan_index.Clear()
[void]$cyan_index.Add($hole_column + 162)
[void]$cyan_index.Add($hole_column + 172)
[void]$cyan_index.Add($hole_column + 182)

switch ($cyan_index)
{
    default
    {
        if($source_table[0].field_current[$_] -eq 0)
        {
            $source_table[0].field_current[$_] = 1
        }
        else
        {
            $source_table[0].field_current[$_] = 8
        }
    }
}

#O または X で塗りつぶす
$yellow_index.Clear()
[void]$yellow_index.Add($hole_column + 163)
[void]$yellow_index.Add($hole_column + 173)
[void]$yellow_index.Add($hole_column + 183)

if($hole_column -le 5)
{
    [void]$yellow_index.Add($hole_column + 154)
}

switch ($yellow_index)
{
    default
    {
        if($source_table[0].field_current[$_] -eq 0)
        {
            $source_table[0].field_current[$_] = 3
        }
        else
        {
            $source_table[0].field_current[$_] = 8
        }
    }
}

#2 ページ目

#I または X で塗りつぶす
$cyan_index.Clear()
[void]$cyan_index.Add($hole_column + 172)
[void]$cyan_index.Add($hole_column + 182)

switch ($cyan_index)
{
    default
    {
        if($source_table[1].field_current[$_] -eq 0)
        {
            $source_table[1].field_current[$_] = 1
        }
        else
        {
            $source_table[1].field_current[$_] = 8
        }
    }
}

#O または X で塗りつぶす
$yellow_index.Clear()
[void]$yellow_index.Add($hole_column + 153)
[void]$yellow_index.Add($hole_column + 163)
[void]$yellow_index.Add($hole_column + 173)
[void]$yellow_index.Add($hole_column + 183)

if($hole_column -le 5)
{
    [void]$yellow_index.Add($hole_column + 154)
}

switch ($yellow_index)
{
    default
    {
        if($source_table[1].field_current[$_] -eq 0)
        {
            $source_table[1].field_current[$_] = 3
        }
        else
        {
            $source_table[1].field_current[$_] = 8
        }
    }
}

#3 ページ目

#I または X で塗りつぶす
$cyan_index.Clear()
[void]$cyan_index.Add($hole_column + 163)
[void]$cyan_index.Add($hole_column + 173)
[void]$cyan_index.Add($hole_column + 183)

switch ($cyan_index)
{
    default
    {
        if($source_table[2].field_current[$_] -eq 0)
        {
            $source_table[2].field_current[$_] = 1
        }
        else
        {
            $source_table[2].field_current[$_] = 8
        }
    }
}

#4 ページ目

#I または X で塗りつぶす
$cyan_index.Clear()
[void]$cyan_index.Add($hole_column + 173)
[void]$cyan_index.Add($hole_column + 183)

switch ($cyan_index)
{
    default
    {
        if($source_table[3].field_current[$_] -eq 0)
        {
            $source_table[3].field_current[$_] = 1
        }
        else
        {
            $source_table[3].field_current[$_] = 8
        }
    }
}

#O または X で塗りつぶす
if($hole_column -le 5)
{
    if($source_table[3].field_current[$hole_column + 154] -eq 0)
    {
        $source_table[3].field_current[$hole_column + 154] = 3
    }
    else
    {
        $source_table[3].field_current[$hole_column + 154] = 8
    }
}

#5 ページ目
#I または X で塗りつぶす
if($source_table[4].field_current[$hole_column + 183] -eq 0)
{
    $source_table[4].field_current[$hole_column + 183] = 1
}
else
{
    $source_table[4].field_current[$hole_column + 183] = 8
}


#field_updated の指定
switch (0..5)
{
    default
    {
        $source_table[$_].field_updated = $source_table[$_].field_current
    }
}

#重複ページがないか確認
$source_page_index_hashset = [hashset[Int]]::new(6)
foreach($page in 0..($source_table.Count - 1))
{
    $add_flag = $true
    switch($source_page_index_hashset)
    {
        default
        {
            if([Linq.Enumerable]::SequenceEqual($source_table[$page].field_current, $source_table[$_].field_current))
            {
                $add_flag = $false
                break
            }
        }
    }

    if($add_flag)
    {
        [void]$source_page_index_hashset.Add($page)
    }
}

#setup に通すテト譜
$Tetfu_Setup = EditFumen_TableToRaw $source_table[$source_page_index_hashset]

#
$setup_result = [List[String]]::new()

foreach($Page_Setup in (1..$source_page_index_hashset.Count))
{
    java -jar sfinder.jar setup -t $Tetfu_Setup -P $Page_Setup -p $patterns -f I -m O -e holes -op "row(1)" "row(2)" "row(3)" "clear()" -np $need_pieces -fo csv
    $setup_result.AddRange([List[String]](Select-String -Path output\setup.csv -Pattern "v115@[a-zA-z0-9+/?]+" -AllMatches -Encoding default | %{$_.Matches.Value}))
}

#
$concat_tetfu_table = [List[Object]]::new($setup_result.count)

switch($setup_result)
{
    default
    {
        $concat_tetfu_table.AddRange((EditFumen_RawToTable $_))
    }
}

#$concat_tetfu_table 


switch($concat_tetfu_table)
{
    default
    {
        $_.flag_comment = 0
        $_.comment_current_length = 0
        $_.comment_current = ''
        $_.comment_updated_length = 0
        $_.comment_updated = ''
        $_.field_current[$hole_column + 179] = 0
        $_.field_current[$hole_column + 189] = 5
        $_.field_current[$hole_column + 199] = 5
        $_.field_current[$hole_column + 200] = 5
        $_.field_current[$hole_column + 209] = 5

        #フィールドの更新
        $field_updated = New-Object List[int]([List[int[]]]$_.field_current)
        $field_updated = EditTable_UpdateField $field_updated 0 0 0 1 0 0

        $_.field_updated = $field_updated
    }
}

#EditFumen_TableToRaw $concat_tetfu_table



#重複ページの確認
$concat_tetfu_page_index_hashset = [hashset[Int]]::new($concat_tetfu_table.Count)
foreach($page in 0..($concat_tetfu_table.Count - 1))
{
    $add_flag = $true
    switch($concat_tetfu_page_index_hashset)
    {
        default
        {
            if([Linq.Enumerable]::SequenceEqual($concat_tetfu_table[$page].field_current, $concat_tetfu_table[$_].field_current))
            {
                $add_flag = $false
                break
            }
        }
    }

    if($add_flag)
    {
        [void]$concat_tetfu_page_index_hashset.Add($page)
    }
}

#フィールドを 4 の倍数以外に分割しているものを除去
switch($concat_tetfu_page_index_hashset)
{
    default
    {
        #
        #$concat_tetfu_table[$_]

        #$concat_tetfu_table[0].field_current

        $blocks_by_column = [List[int]](@(0) * 10)

        foreach($block_index in (150..229))
        {
            #
            if($concat_tetfu_table[$_].field_current[$block_index])
            {
                #
                $blocks_by_column[$block_index % 10]++
            }
        }

        $select_this_pattern = $true

        $blocks_counter = 0
        foreach($column_index in (0..9))
        {
            #
            if($blocks_by_column[$column_index] -eq 8)
            {
                if($blocks_counter % 4)
                {
                    $select_this_pattern = $false
                    break
                }
            }
            $blocks_counter += $blocks_by_column[$column_index]
        }

        if($select_this_pattern)
        {
            #

        }
        else
        {
            [void]$concat_tetfu_page_index_hashset.Remove($_)
        }
    }
}

#
$Tetfu_Percent_A = EditFumen_TableToRaw $concat_tetfu_table[$concat_tetfu_page_index_hashset]
$Tetfu_Percent_B = Update-Field $Tetfu_Percent_A
$Tetfu_Percent_C = Set-To-Gray $Tetfu_Percent_A
$Tetfu_Percent_C_Table = EditFumen_RawToTable $Tetfu_Percent_C

$Pattern_List = [List[String]]::new($concat_tetfu_page_index_hashset.Count)

foreach($Page_Percent in (1..$concat_tetfu_page_index_hashset.Count))
{
    java -jar sfinder.jar percent -t $Tetfu_Percent_B -P $Page_Percent -p *! -c 5
    $Pattern_Num = [Int](Select-String -Path output\last_output.txt -Pattern "(?<=^success = .+?% \().+?(?=/)" -AllMatches -Encoding default | %{$_.Matches.Value})

    $rate_val = 100 * $Pattern_Num / 5040
    $rate_str = $rate_val.ToString("0.00")
    $escaped_cmt = "{0:0.00}%20%25%20%5B{1}/5040%5D" -f $rate_val, $Pattern_Num
    $cmt_base64 = ''
    $cmt_base64 += 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'.Substring(($escaped_cmt.Length % 64), 1)
    $cmt_base64 += 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'.Substring(([Math]::Floor($escaped_cmt.Length / 64)), 1)
    $escaped_cmt = $escaped_cmt.PadRight($escaped_cmt.Length + (4 - ($escaped_cmt.Length % 4)) % 4)
    $cmt_char = ([System.Text.Encoding]::Default).GetBytes($escaped_cmt)
    $cmt_base96 = 0

    foreach($j in 0..($escaped_cmt.Length / 4 - 1))
    {
        foreach($k in 0..3)
        {
            $cmt_base96 += ($cmt_char[4 * $j + $k] - 32) * [Math]::pow(96, $k)
        }

        foreach($k in 0..4)
        {
            $cmt_base64 += 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'.Substring(($cmt_base96 % 64), 1)
            $cmt_base96 = ([Math]::Floor($cmt_base96 / 64))
        }
    }

    $raw_by_patterns = (Get-Pages $Tetfu_Percent_A $Page_Percent)

    $raw_by_patterns = $raw_by_patterns -replace '\?', ''
    $raw_by_patterns = $raw_by_patterns.Substring(0, $raw_by_patterns.Length - 1) + 'W' + $cmt_base64

    for($i = 0; (48 * $i + 47) -le ($raw_by_patterns.Length); $i++)
    {
        $raw_by_patterns = $raw_by_patterns.Insert(48 * $i + 47,'?')
    }

    $Pattern_List.Add(("{0:0000} {1} {2}" -f $Pattern_Num, (-join $Tetfu_Percent_C_Table[$Page_Percent - 1].field_current), $raw_by_patterns))
}

$Pattern_List.Sort()
$Pattern_List.Reverse()

$Pattern_Raw_List = [List[String]]::new($concat_tetfu_page_index_hashset.Count)

Switch($Pattern_List)
{
    default
    {
        $raw_by_patterns = (Select-String -InputObject $_ -Pattern "(?<!^0000.+)v115@[a-zA-z0-9+/?]+$" -AllMatches -Encoding default | %{$_.Matches.Value})
    
        if($raw_by_patterns.Count)
        {
            $Pattern_Raw_List.Add($raw_by_patterns)
        }
    }
}

Write-Output '#Output' ('{0} solutions' -f ($Pattern_Raw_List.Count)) (Concat-Fumen $Pattern_Raw_List) | Out-File output/last_output.txt

''
''
Get-Content output/last_output.txt
