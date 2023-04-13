#-----------------------------------------------------------------------------#
# Demo 1 - Instantiate an object from .Net Code in embedded code
#-----------------------------------------------------------------------------#

$code = @"
using System;

public class SchemaTable
{
  public string DatabaseName;

  public string SchemaTableName(string pSchema, string pTable)
  {
    string retVal = "";  // Setup a return variable

    retVal = pSchema + "." + pTable;

    return retVal;

  } // public SchemaTableName

  public string FullName(string pSchema, string pTable)
  {
    string retVal = "";  // Setup a return variable

    retVal = this.DatabaseName + "." + pSchema + "." + pTable;

    return retVal;

  } // public FullName

} // class SchemaTable

"@

# Add a new type definition based on the code
Add-Type -TypeDefinition $code `
         -Language CSharp

# Instantiate a new version of the object
$result = New-Object -TypeName SchemaTable

$result | Get-Member

# Set and display the property
$result.DatabaseName = 'MyDB'
$result.DatabaseName

$result.SchemaTableName('ASchema', 'ATable')

$result.FullName('ASchema', 'ATable')



#-----------------------------------------------------------------------------#
# Demo 2 - Create a class from .Net Code and call a static method
#-----------------------------------------------------------------------------#

# Create a variable holding the definition of a class
$code = @"
using System;

public class StaticSchemaTable
{
  public static string FullName(string pSchema, string pTable)
  {
    string retVal = "";

    retVal = pSchema + "." + pTable;

    return retVal;

  } // public static FullName
} // class StaticSchemaTable
"@

# Add a new type definition based on the code
Add-Type -TypeDefinition $code

# Call the static method of the object
$result = [StaticSchemaTable]::FullName('MySchema', 'myTable')
$result

#-----------------------------------------------------------------------------#
# Demo 3 - Create object from .Net Code in an external file
#-----------------------------------------------------------------------------#

# Set the folder where the CS file is
$csPath = 'C:\Users\arcan\OneDrive\BlogPosts\Markdown\'

# Path and File Name
$file = "$($csPath)Fun-With-PowerShell-Objects-Part 3.cs"

# Display contents of the file
psedit $file

# Load the contents of the file into a variable
$code = Get-Content $file | Out-String

# Add a new type definition based on the code
Add-Type -TypeDefinition $code

# Call the static method of the object
$result = [StaticSchemaTableInFile]::FullName('mySchema', 'myTable')
$result
