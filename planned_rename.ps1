param([String]$src="", [String]$des="", [String]$type="*.*", [String]$rules="")

if(!(Test-Path -Path $des )){
    New-Item -ItemType directory -Path $des
}
$_Rules = Import-Csv $rules #| Write-Host "SrcName=" + $_.name | Write-Host "DesName=" + $_.rename | Write-Host "append=" + $_.append 

#Write-Output $_Rules.name
Get-ChildItem $src -recurse -force -Filter $type | 
Foreach-Object {
    Foreach ($rule in $_Rules)
    {
        #$r_n = "?" + $rule.name + "?"
        $r_n = $rule.name
        #write-output $r_n
        #Write-Output $_.FullName
        
        if ($_.Name -like "*$r_n*") { 
            Write-Output "Match"
            $rn_rule = $rule.rename + $rule.append
            $newfilename = $_.Name -replace "$r_n",$rn_rule
            $newfilename_tmp = $src + "\" + $newfilename
            $newfilename_full= $des + "\" + $newfilename
            $oldfilename_full = $_.FullName
            $save = 0
            #write-output $oldfilename_full
            #
            #
            #
            #
            #Write-Output $newfilename_full
            while ($true){
                if(!(Test-Path -Path $newfilename_full )){
                    Rename-Item -Path $oldfilename_full -NewName $newfilename
                    Move-Item -Path $newfilename_tmp -Destination $newfilename_full
                    #Rename-Item -Path $oldfilename_full -NewName $newfilename_full
                    write-output "Renamed $oldfilename_full to $newfilename_full"
                    break
                }else{
                    $newinc = $i++
                    if ($i > 1){
                        $newfilename_full = $newfilename_full -replace "$i","$i++"
                    }
                    else{
                        $newfilename_full = $newfilename_full + "_" + $i
                    }
                }
            }
        }
    }

}
