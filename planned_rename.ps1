param([String]$src="", [String]$des="", [String]$type="*.*", [String]$rules="",[String]$append="")
$_MOVE=1
$_APPEND=1
if($src -eq ""){exit}
if($rules -eq ""){exit}
if($src -eq $des){
    Write-Output "Move Disabled"
    $_MOVE = 0
}else{Write-Output "Move Enabled"}
if($append -eq ""){
    Write-Output "Append Disabled"
    $_APPEND = 0
}
if(!(Test-Path -Path $des )){
    New-Item -ItemType directory -Path $des
}
$_Rules = Import-Csv $rules 
Get-ChildItem $src -recurse -force -Filter $type | 
Foreach-Object {
    Foreach ($rule in $_Rules)
    {
        
        $r_n = $rule.name        
        if ($_.Name -like "*$r_n*") { 
            Write-Output "Match"
            if($_APPEND -eq 1){
                $rn_rule = $rule.rename + $rule.append
            }else{
                $rn_rule = $rule.rename
            }
            $newfilename = $_.Name -replace "$r_n",$rn_rule
            $newfilename_tmp = $src + "\" + $newfilename
            $newfilename_full= $des + "\" + $newfilename
            $oldfilename_full = $_.FullName
            while ($true){
                $i = 0
                if(!(Test-Path -Path $newfilename_full )){
                    Rename-Item -Path $oldfilename_full -NewName $newfilename
                    if($_MOVE -eq 1){Move-Item -Path $newfilename_tmp -Destination $newfilename_full}
                    write-output "Renamed $oldfilename_full to $newfilename_full"
                    break
                }else{
                    $i++
                    $rn_rule = $rn_rule + "_" + $i
                    $newfilename = $_.Name -replace "$r_n",$rn_rule
                    $newfilename_tmp = $src + "\" + $newfilename
                    $newfilename_full= $des + "\" + $newfilename
                }
            }
        }
    }

}
