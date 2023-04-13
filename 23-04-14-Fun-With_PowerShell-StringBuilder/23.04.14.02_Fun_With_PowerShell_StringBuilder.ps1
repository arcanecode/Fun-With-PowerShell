# Append ----------------------------------------------------------------------------------------
$output = [System.Text.StringBuilder]::new()
[void]$output.Append( 'PowerShell is awesome!' )
[void]$output.Append( ' It makes my life much easier.' )
[void]$output.Append( ' I think I''ll go watch some of Robert''s videos on Pluralsight.' )
$output.ToString()

<# Output
PowerShell is awesome! It makes my life much easier. I think I'll go watch some of Robert's videos on Pluralsight.
#>

# AppendLine ------------------------------------------------------------------------------------
$output = [System.Text.StringBuilder]::new()
[void]$output.Append( 'PowerShell is awesome!' )
[void]$output.AppendLine( ' It makes my life much easier.' )
[void]$output.Append( 'I think I''ll go watch some of Robert''s videos on Pluralsight.' )
$output.ToString()

<# Output
PowerShell is awesome! It makes my life much easier.
I think I'll go watch some of Robert's videos on Pluralsight.
#>

$output = [System.Text.StringBuilder]::new()
[void]$output.Append( 'PowerShell is awesome!' )
[void]$output.AppendLine( ' It makes my life much easier.' )
[void]$output.AppendLine()
[void]$output.Append( 'I think I''ll go watch some of Robert''s videos on Pluralsight.' )
$output.ToString()

<# Output
PowerShell is awesome! It makes my life much easier.

I think I'll go watch some of Robert's videos on Pluralsight.
#>

# AppendFormat ----------------------------------------------------------------------------------

$value = 33
$output = [System.Text.StringBuilder]::new()
[void]$output.Append( 'The value is: ' )
[void]$output.AppendFormat( "{0:C}", $value )
$output.ToString()


# Insert ----------------------------------------------------------------------------------------
$output = [System.Text.StringBuilder]::new()
[void]$output.Append( 'Arcane' )
[void]$output.Append( ' writes great blog posts.' )
[void]$output.Insert(6, 'Code')
$output.ToString()

<# Output
ArcaneCode writes great blog posts.
#>

# Remove ----------------------------------------------------------------------------------------
$output = [System.Text.StringBuilder]::new()
[void]$output.Append( 'ArcaneCode' )
[void]$output.Append( ' writes great blog posts.' )
[void]$output.Remove(6, 4)
$output.ToString()

<# Output
Arcane writes great blog posts.
#>

# Replace ---------------------------------------------------------------------------------------
$output = [System.Text.StringBuilder]::new()
[void]$output.Append( 'ArcaneCode' )
[void]$output.AppendLine( ' writes great blog posts.' )
[void]$output.Append( 'I think I''ll go watch some of Robert''s videos on Pluralsight.' )
[void]$output.Replace('.', '!')
$output.ToString()

<# Output
ArcaneCode writes great blog posts!
#>

# Stacking Methods ------------------------------------------------------------------------------
$output = [System.Text.StringBuilder]::new()
[void]$output.Append( '[ArcaneCode]' ).Replace('[', '').Replace(']', '').Insert(6, ' ')
$output.ToString()


#------------------------------------------------------------------------------------------------
# Adding the first string when the object is created from the stringbuilder class
$output = [System.Text.StringBuilder]::new('ArcaneCode')
[void]$output.Append( ' writes great blog posts.' )
$output.ToString()

<# Output
ArcaneCode writes great blog posts.
#>

