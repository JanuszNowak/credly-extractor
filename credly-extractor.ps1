$u="https://www.credly.com/users/janusz-nowak/badges"

 
$res=Invoke-WebRequest -Uri $u

$Pre = $res.AllElements | Where {$_.TagName -eq "li"} | where  {$_.Class -eq "data-table-row data-table-row-grid"} 


$template = @'
<a href="https://www.credly.com${badge}" title="${title}">
    <img src="${img}" width="140" alt="${title}"/>
</a>
'@

ForEach($p in $Pre)
{
    $pp=$p.innerHTML.Replace("<DIV class=cr-standard-grid-item-content__title>","").Replace("<DIV class=cr-standard-grid-item-content__details>","").Replace("<DIV class=cr-standard-grid-item-content__subtitle>","").Replace(" </DIV></DIV></DIV></A></DIV>","").Replace(" </DIV>","").Replace("cr-standard-grid-item-content c-badge c-badge--medium","").Replace("col-12 col data-table-content","").Replace("c-grid-item c-grid-item--stack-lt-sm cr-public-earned-badge-grid-item","")
    $pp=$pp.Replace("><IMG class=cr-standard-grid-item-content__image alt=","").Replace("<DIV class=","").Replace("><A title=","").Replace('""','').Replace("&amp;","&").Replace('">',"").Replace(" class= ","").Replace(' src=',"").Replace("`n","").Replace(" `r`n","")#.Replace('"href="',

    $pp=$pp.Trim()
    #$pp
    $split=$pp.Split([Environment]::NewLine)

    #$split#[0]
    $badge=$split[0].Replace('"href="',"|").Replace('"','').Replace($split[3],"").Replace('|','')
    #$badge
    $img=$split[1].Replace('"','').Trim().Replace("110x110","140x140")
    #$img
    $title=$split[3]
    #$title
    $company= $split[4]
    #$company

    $expanded = $ExecutionContext.InvokeCommand.ExpandString($template)
    $expanded
}
