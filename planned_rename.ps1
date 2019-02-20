param([String]$src="", [String]$des="", [String]$type="*.*", [String]$rules="")
$_MOVE=1
if($src -eq ""){exit}
if($rules -eq ""){exit}
if($src -eq $des){
    Write-Output "Move Disabled"
    $MOVE = 0
}else{Write-Output "Move Enabled"}
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
            $rn_rule = $rule.rename + $rule.append
            $newfilename = $_.Name -replace "$r_n",$rn_rule
            $newfilename_tmp = $src + "\" + $newfilename
            $newfilename_full= $des + "\" + $newfilename
            $oldfilename_full = $_.FullName
            while ($true){
                $i = 0
                if(!(Test-Path -Path $newfilename_full )){
                    Rename-Item -Path $oldfilename_full -NewName $newfilename
                    if($_MOVE = 1){Move-Item -Path $newfilename_tmp -Destination $newfilename_full}
                    write-output "Renamed $oldfilename_full to $newfilename_full"
                    break
                }else{
                    $newinc = "_" + $i++
                    $curinc = "_" + $i
                    if ($curinc > 0){
                        $newfilename_full = $newfilename_full -replace $curinc,$newinc
                    }
                    else{
                        $i++
                        $newfilename_full = $newfilename_full + "_" + $i
                    }
                    $i++
                }
            }
        }
    }

}
