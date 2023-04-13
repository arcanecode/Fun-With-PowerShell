Set-Location C:\Users\arcan\OneDrive\BlogPosts\Markdown

$items = Get-ChildItem

# Returns a collection of DirectoryInfo objects (System.IO.FileSystemInfo)
$items[0].GetType()

# Define the custom script property
$script = {

  switch ($this.Extension)
  {
    '.cs'   {$retValue = 'C#'}
    '.md'   {$retValue = 'Markdown'}
    '.ps1'  {$retValue = 'Script'}
    '.psd1' {$retValue = 'Module Definition'}
    '.psm1' {$retValue = 'Module'}
    '.xml'  {$retValue = 'XML File'}
    '.pptx' {$retValue = 'PowerPoint'}
    '.csv'  {$retValue = 'Comma Separated Values file'}
    '.json' {$retValue = 'JavaScript Object Notation data'}
    default {$retValue = 'Sorry dude, no clue.'}
  }
  return $retValue
}

# Create an item count variable
$itemCount = 0

# Iterate over each DirectoryInfo object in the $items collection
foreach($item in $items)
{
  # Add a note property, setting it to the current item counter
  $itemCount++
  $item | Add-Member –MemberType NoteProperty `
                     –Name ItemNumber `
                     –Value $itemCount

  # Add script property to the individual file object
  Add-Member -InputObject $item `
             -MemberType ScriptMethod `
             -Name 'ScriptType' `
             -Value $script 

  # Now display the already existing Name property along with the
  # property and method we just added.
  "$($item.ItemNumber): $($item.Name) = $($item.ScriptType())"
}


