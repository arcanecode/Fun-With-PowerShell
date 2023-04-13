#-----------------------------------------------------------------------------#
# Demo 1 -- Create a new object 
# This is the most common method of creating objects
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

  # Return the newly created object
  return $object
}

$myObject = Create-Object -Schema 'MySchema' -Table 'MyTable' -Comment 'MyComment'

# Display all properties
$myObject

# Display a single property
$myObject.Schema

# Prove it is of type PSCustomObject
$myObject.GetType()

# Display in text. Note because it is an object need to wrap in $() to access a property
"My Schema = $($myObject.Schema)"

# Assign Values to the properties
$myObject.Schema = 'New Schema'
$myObject.Comment = 'New Comment'
$myObject

#-----------------------------------------------------------------------------#
# Demo 2 -- Create a new object by adding properties one at a time
# In the previous demo a property hash table was used to generate the object
# Behind the scenes it does the equivalent of what this function does
#-----------------------------------------------------------------------------#
function Create-Object ($Schema, $Table, $Comment)
{
  # Start by creating an object of type PSObject
  $object = New-Object –TypeName PSObject

  # Add-Member by passing in input object
  Add-Member -InputObject $object `
             –MemberType NoteProperty `
             –Name Schema `
             –Value $Schema

  # Alternate syntax, pipe the object as an input to Add-Member
  $object | Add-Member –MemberType NoteProperty `
                       –Name Table `
                       –Value $Table
  
  $object | Add-Member -MemberType NoteProperty `
                       -Name Comment `
                       -Value $Comment

  return $object
}

$myObject = Create-Object -Schema 'MySchema' -Table 'MyTable' -Comment 'MyComment'
$myObject

# Display in text. Note because it is an object need to wrap in $() to access a property
"My Schema = $($myObject.Schema)"

$myObject.Schema = 'New Schema'
$myObject.Comment = 'New Comment'
$myObject

#-----------------------------------------------------------------------------#
# Demo 3 -- Add property aliases
#-----------------------------------------------------------------------------#
# Demo 3.1 -- Add alias to existing property

Add-Member -InputObject $myObject `
           -MemberType AliasProperty `
           -Name 'Description' `
           -Value 'Comment' `
           -PassThru

$myObject.Description = 'The Description'
$myObject

"Comment......: $($myObject.Comment)"
"Description..: $($myObject.Description)"


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
