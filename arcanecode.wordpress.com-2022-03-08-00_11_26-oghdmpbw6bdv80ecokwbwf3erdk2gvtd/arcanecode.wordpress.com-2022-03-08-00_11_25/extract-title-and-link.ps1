$wpInput = 'C:\Users\arcan\OneDrive\BlogPosts\Markdown\arcanecode.wordpress.com-2022-03-08-00_11_26-oghdmpbw6bdv80ecokwbwf3erdk2gvtd\arcanecode.wordpress.com-2022-03-08-00_11_25\arcanecode.wordpress.2022-03-08.000.xml'
$wpOutput = 'C:\Users\arcan\OneDrive\BlogPosts\Markdown\arcanecode.wordpress.com-2022-03-08-00_11_26-oghdmpbw6bdv80ecokwbwf3erdk2gvtd\arcanecode.wordpress.com-2022-03-08-00_11_25\arcanecode.wordpress.md'

$inData = Get-Content $wpInput

# Setup an empty array for the output
$outData = @()
foreach ($line in $inData)
{

  if ($line.Trim().StartsWith('<title>'))
  {
    $outLine = $line.Trim()
    $outLine = $outLine.Replace('<title>', '[')
    $outLine = $outLine.Replace('</title>', ']')
  }

  if ($line.Trim().StartsWith('<link>'))
  {
    $outLine = $outLine + $line.Trim()
    $outLine = $outLine.Replace('<link>', '(')
    $outLine = $outLine.Replace('</link>', ')')
    $outData += $outLine
    $outLine = ''
  }

}

Out-File -FilePath $wpOutput -InputObject $outData -Force
