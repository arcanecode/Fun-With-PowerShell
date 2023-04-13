#------------------------------------------------------------------------------------------------
# Function..: Get-WPObject
# Author....: Robert C. Cain | @ArcaneCode | http://arcanecode.me
# Purpose...: Creates a custom object from the passed in values
#
# Notes
#   This code is Copyright (c) 2022 Robert C. Cain. All rights reserved.
#
#   The code herein is for demonstration purposes. No warranty or guarantee
#   is implied or expressly granted.
#
#------------------------------------------------------------------------------------------------
function Get-WPObject()
{
  [CmdletBinding()]
  param (
          [Parameter( Mandatory = $true ) ]
          [string] $Title
        , [Parameter( Mandatory = $true ) ]
          [string] $Link
        , [Parameter( Mandatory = $true ) ]
          [string] $PubDate
        )

  # Build a hash table with the properties
  $properties = [ordered]@{ Title = $Title
                            Link = $Link
                            PubDate = $PubDate
                          }

  # Start by creating an object of type PSObject
  $object = New-Object –TypeName PSObject `
                       -Property $properties

  # Return the newly created object
  return $object
}



$wpInput = 'D:\OneDrive\BlogPosts\Markdown\arcanecode.wordpress.2022-04-02.000.xml'
$wpOutputCsv = 'D:\OneDrive\BlogPosts\Markdown\arcanecode.wordpress2.csv'
$wpOutputHtml = 'D:\OneDrive\BlogPosts\Markdown\arcanecode.wordpress2.html'
$wpOutputMd = 'D:\OneDrive\BlogPosts\Markdown\arcanecode.wordpress2.md'

# Read the data from input file
$inData = Get-Content $wpInput

# Setup an empty array to hold the output
$outData = @()

foreach ($line in $inData)
{

  # Extract the title. Replace the XML tags with the Markdown for a link title
  if ($line.Trim().StartsWith('<title>'))
  {
    $title = $line.Trim().Replace('<title>', '').Replace('</title>', '')
  }

  # Extract the link, replacing the XML tags with the Markdown link characters
  if ($line.Trim().StartsWith('<link>'))
  {
    $link = $line.Trim().Replace('<link>', '').Replace('</link>', '')

    # For some reason the Wordpress export uses http instead of https. Since the
    # blog supports https, lets fix that.
    $link = $link.Replace('http:', 'https:')
  }

  if ($line.Trim().StartsWith('<pubDate>'))
  {
    # Extract just the date, then covert it to a DateTime datatype
    $pubDateTemp = [DateTime]($line.Trim().Replace('<pubDate>', '').Replace('</pubDate>', ''))

    # Now use the ToString feature of a DataTime datatype to format the date
    $pubDate = $pubDateTemp.ToString('yyyy-MM-dd')

    # In addition to links to the blog posts themselves, the exported XML file also
    # has links to images. To weed these out, we will search for posts that have PowerShell
    # in the title. The Contains method is case sensitive so it will omit the links
    # to the images.
    #
    # When a match is found, it passes the Title/Link/PubDate to our function, which will
    # generate a custom object. This object will be added to our output array.
    if ($title.Contains('PowerShell'))
    {
      $outData += Get-WPObject -Title $title -Link $link -PubDate $pubDate
    }

  }

} # End the foreach ($line in $inData) loop


#$outData

#Out-File -FilePath $wpOutput -InputObject $outData -Force
#$outData | Export-Csv -Path $wpOutputCsv -NoTypeInformation -Force

#------------------------------------------------------------------------------------------------
# Output as HTML
#------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------
# Function..: Get-WPHtml
# Author....: Robert C. Cain | @ArcaneCode | http://arcanecode.me
# Purpose...: Takes the input and formats each line as HTML
#
# Notes
#   This code is Copyright (c) 2022 Robert C. Cain. All rights reserved.
#
#   The code herein is for demonstration purposes. No warranty or guarantee
#   is implied or expressly granted.
#
#------------------------------------------------------------------------------------------------
function Get-WPHtml()
{
  [CmdletBinding()]
  param (
          [Parameter (ValuefromPipeline)] $wpObjects
        , [Parameter (Mandatory = $false)] $Indent = 0
        , [switch] $FormatAsTable
        )

  process
  {
    # Create a string with spaces to indent the code. If not used no indent is created.
    $space = ' ' * $Indent

    # Create a formatted output line
    if (!$FormatAsTable.IsPresent)
    {
      # Create each line as a paragraph
      $outLine = @"
$space<p>$($wpObjects.PubDate) - <a href="$($wpObjects.Link)" target=blank>$($wpObjects.Title)</a></p>
"@
    }
    else
    {
      # Create each line as a row in a table
      $outLine = @"
$space<tr> <td>$($wpObjects.PubDate)</td> <td><a href="$($wpObjects.Link)" target=blank>$($wpObjects.Title)</a></td> </tr>
"@
    }

    # Return the formatted line
    $outLine
  }

}


$outHtml = $outData | Get-WPHtml -Indent 2

# Save the new array to a file. Use Force to overwrite the file if it exists
Out-File -FilePath $wpOutputHtml -InputObject $outHtml -Force


$outHtml = $outData | Get-WPHtml -FormatAsTable -Indent 2

#------------------------------------------------------------------------------------------------
# Function..: Add-WPHtmlHeader
# Author....: Robert C. Cain | @ArcaneCode | http://arcanecode.me
# Purpose...: Adds some extra lines to the array to add an HTML header to the table
#
# Notes
#   This code is Copyright (c) 2022 Robert C. Cain. All rights reserved.
#
#   The code herein is for demonstration purposes. No warranty or guarantee
#   is implied or expressly granted.
#
#------------------------------------------------------------------------------------------------
function Add-WPHtmlHeader()
{
  [CmdletBinding()]
  param (
          [Parameter (Mandatory = $true)]
          $htmlData
        )

  # Create a new array
  $outTable = @()

  # Add the html to create a left aligned table header
  $outTable += '<style>th { text-align: left; } </style>'
  $outTable += '<table>'
  $outTable += '<tr>'
  $outTable += '<th>Date</th> <th>Post</th>'
  $outTable += '</th>'

  # Add the existing table row data
  foreach ($row in $htmlData) { $outTable += $row }

  # Add the closing table tag
  $outTable += '</table>'

  # Return the output
  return $outTable
}


$outTable = Add-WPHtmlHeader $outHtml

# Save the new array to a file. Use Force to overwrite the file if it exists
Out-File -FilePath $wpOutputHtml -InputObject $outTable -Force



#------------------------------------------------------------------------------------------------
# Create an MD file
#------------------------------------------------------------------------------------------------


function Get-WPMarkdown()
{
  [CmdletBinding()]
  param (
          [Parameter (ValuefromPipeline)] $wpObjects
        , [switch] $FormatAsTable
        )

  process
  {
    # Create a formatted output line
    if (!$FormatAsTable.IsPresent)
    {
      # Create each line as a paragraph
      $outLine = @"
$($wpObjects.PubDate) - [$($wpObjects.Title)]($($wpObjects.Link))
"@
    }
    else
    {
      # Create each line as a row in a table
      $outLine = @"
|$($wpObjects.PubDate)|[$($wpObjects.Title)]($($wpObjects.Link))|
"@
    }

    # Return the formatted line
    $outLine
  }

}


$outMd = $outData | Get-WPMarkdown -FormatAsTable

Out-File -FilePath $wpOutputMd -InputObject $outMd -Force




function Add-WPMarkdownHeader()
{
  [CmdletBinding()]
  param (
          [Parameter (Mandatory = $true)]
          $markdownData
        )

  # Create a new array
  $outTable = @()

  # Add the html to create a left aligned table header
  $outTable += '|Date|Post|'
  $outTable += '|:-----|:-----|'

  # Add the existing table row data
  foreach ($row in $markdownData) { $outTable += $row }

  # Return the output
  return $outTable
}


$outTable = Add-WPMarkdownHeader $outMd
Out-File -FilePath $wpOutputMd -InputObject $outTable -Force



#------------------------------------------------------------------------------------------------



$outFile = @()

# Read each line in the input file
foreach ($line in $outData)
{

  $outLine = @"
$($line.PubDate) - [$($line.Title)]($($line.Link))
"@

  $outFile += $outLine

  # Reset our variable so it is ready for the next pass in the loop
  $outLine = ''

} # End the foreach ($line in $inData) loop

# Save the new array to a file. Use Force to overwrite the file if it exists
Out-File -FilePath $wpOutputMd -InputObject $outFile -Force




#------------------------------------------------------------------------------------------------
# When you do an export on a wordpress blog, it dumps all of the data as an XML file.
# We are only interested in two lines, those that have the title of a blog post, denoted by
# the <title> tag, and the link, denoted by the <link> tag.
#
# This script will go over the exported XML file and extract just those two lines. It will
# then reformat them as a Markdown link. It will then write the output to a second file.
#------------------------------------------------------------------------------------------------

# Set the paths for the input and output files
#$wpInput = 'C:\Users\arcan\OneDrive\BlogPosts\Markdown\arcanecode.wordpress.2022-03-08.000.xml'
#$wpOutput = 'C:\Users\arcan\OneDrive\BlogPosts\Markdown\arcanecode.wordpress.html'
$wpInput = 'D:\OneDrive\BlogPosts\Markdown\arcanecode.wordpress.2022-03-08.000.xml'
$wpOutput = 'D:\OneDrive\BlogPosts\Markdown\arcanecode.wordpress2.html'

# Read the data from input file
$inData = Get-Content $wpInput

# Setup an empty array to hold the output
$outData = @()

# Read each line in the input file
foreach ($line in $inData)
{

  # Extract the title. Replace the XML tags with the Markdown for a link title
  if ($line.Trim().StartsWith('<title>'))
  {
    $outLine = $line.Trim().Replace('<title>', '').Replace('</title>', '</a></p>')
  }

  # Extract the link, replacing the XML tags with the Markdown link characters
  if ($line.Trim().StartsWith('<link>'))
  {
    $outLine = $line.Trim().Replace('<link>', '<p><a href="').Replace('</link>', '" target=blank>') + $outLine

    # For some reason the Wordpress export uses http instead of https. Since the
    # blog supports https, lets fix that.
    $outLine = $outLine.Replace('http:', 'https:')

    # For this script we are only interested in blog entries that have the PowerShell
    # tag, so only those are added to the output
    if ($line.Contains('powershell'))
    {
      $outData += $outLine
    }

    # Reset our variable so it is ready for the next pass in the loop
    $outLine = ''
  }

} # End the foreach ($line in $inData) loop

# Save the new array to a file. Use Force to overwrite the file if it exists
Out-File -FilePath $wpOutput -InputObject $outData -Force


#------------------------------------------------------------------------------------------------
# Markdown
#------------------------------------------------------------------------------------------------







#------------------------------------------------------------------------------------------------
# When you do an export on a wordpress blog, it dumps all of the data as an XML file.
# We are only interested in two lines, those that have the title of a blog post, denoted by
# the <title> tag, and the link, denoted by the <link> tag.
#
# This script will go over the exported XML file and extract just those two lines. It will
# then reformat them as a Markdown link. It will then write the output to a second file.
#------------------------------------------------------------------------------------------------

# Set the paths for the input and output files
$wpInput = 'C:\Users\arcan\OneDrive\BlogPosts\Markdown\arcanecode.wordpress.2022-03-08.000.xml'
$wpOutput = 'C:\Users\arcan\OneDrive\BlogPosts\Markdown\arcanecode.wordpress.md'

# Read the data from input file
$inData = Get-Content $wpInput

# Setup an empty array to hold the output
$outData = @()

# Read each line in the input file
foreach ($line in $inData)
{

  # Extract the title. Replace the XML tags with the Markdown for a link title
  if ($line.Trim().StartsWith('<title>'))
  {
    $outLine = $line.Trim().Replace('<title>', '[').Replace('</title>', ']')
  }

  # Extract the link, replacing the XML tags with the Markdown link characters
  if ($line.Trim().StartsWith('<link>'))
  {
    $outLine = $outLine + $line.Trim().Replace('<link>', '(').Replace('</link>', ')')

    # For some reason the Wordpress export uses http instead of https. Since the
    # blog supports https, lets fix that.
    $outLine = $outLine.Replace('http:', 'https:')

    # For this script we are only interested in blog entries that have the PowerShell
    # tag, so only those are added to the output
    if ($line.Contains('powershell'))
    {
      $outData += $outLine
    }

    # Reset our variable so it is ready for the next pass in the loop
    $outLine = ''
  }

} # End the foreach ($line in $inData) loop

# Save the new array to a file. Use Force to overwrite the file if it exists
Out-File -FilePath $wpOutput -InputObject $outData -Force
