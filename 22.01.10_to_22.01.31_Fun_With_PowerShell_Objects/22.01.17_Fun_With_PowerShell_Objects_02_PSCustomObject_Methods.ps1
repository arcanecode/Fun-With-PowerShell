#-----------------------------------------------------------------------------#
# Preamble - Starting Point
# Picking up where we left off
#-----------------------------------------------------------------------------#
function Create-Object ($Schema, $Table, $Comment)
{
  # Build a hash table with the properties
  $properties = [ordered]@{ Schema = $Schema
                            Table = $Table
                            Comment = $Comment
                          }

  # Start by creating an object of type PSObject
  $object = New-Object –TypeName PSObject -Property $properties

  Add-Member -InputObject $object `
             -MemberType AliasProperty `
             -Name 'Description' `
             -Value 'Comment'

  # Return the newly created object
  return $object
}

$myObject = Create-Object -Schema 'MySchema' `
                          -Table 'MyTable' `
                          -Comment 'MyComment'
$myObject

#-----------------------------------------------------------------------------#
# Demo 1 -- Script Block
#-----------------------------------------------------------------------------#

$x = 1
if ($x -eq 1)
{ Write-Host 'Yep its one' }

# You can place a script block in a variable by putting code in squiggly braces
$hw = {
        Clear-Host
        "Hello World"
      }

# To execute a script held in a variable, simply use an ampersand
& $hw

# The space is optional, can be omitted
&$hw

function Run-AScriptBlock($block)
{
  Write-Host 'About to run a script block'

  & $block

  Write-Host "Block was run"
}

Run-AScriptBlock $hw


#-----------------------------------------------------------------------------#
# Demo 2 -- Adding a simple function
#-----------------------------------------------------------------------------#

# Define the function as a script block
$block = {
           $st = "$($this.Schema).$($this.Table)"
           return $st
         }

# Could also have used
# $st = $this.Schema + '.' + $this.Table

Add-Member -InputObject $myObject `
           -MemberType ScriptMethod `
           -Name 'SchemaTable' `
           -Value $block

# Parens are very important, without it will just display the function
$myObject.SchemaTable()

#-----------------------------------------------------------------------------#
# Demo 3 -- Script block with parameters
#-----------------------------------------------------------------------------#

$block = {
           param ($DatabaseName)
           $dst = "$DatabaseName.$($this.Schema).$($this.Table)"
           return $dst
         }

Add-Member -InputObject $myObject `
           -MemberType ScriptMethod `
           -Name 'DatabaseSchemaTable' `
           -Value $block

# Parens are very important, without it will just display the function
$myObject.DatabaseSchemaTable('MyDBName')
