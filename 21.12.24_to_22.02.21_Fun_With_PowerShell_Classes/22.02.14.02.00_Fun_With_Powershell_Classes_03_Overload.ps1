#------------------------------------------------------------------------------------------------
# Starting Point
#------------------------------------------------------------------------------------------------

<#
class TwittererRedux
{
  # Create a property
  [string]$TwitterHandle

  # Create a property and set a default value
  [string]$Name = 'Robert C. Cain'

  # Static Properties
  static [string] $Version = '2022.01.07.002'

  # Function that returns a string
  [string] TwitterURL()
  {
    # Call the function to build the twitterurl
    # passing in the property we want
    $url = $this.TwitterURL($this.TwitterHandle)

    return $url
  }

  # Function that has no return value
  [void] OpenTwitter()
  {
    Start-Process $this.TwitterURL()
  }

  # Can launch a twitter page without instantiating the class
  static [void] OpenTwitterPage([string] $TwitterHandle)
  {
    # Note here we cannot call the $this.TwitterUrl function
    # because no object exists (hence no $this)
    $url = "http://twitter.com/$($TwitterHandle)"
    Start-Process $url
  }

}

[TwittererRedux]::OpenTwitterPage('ArcaneCode')

[TwittererRedux]::Version

#>

#------------------------------------------------------------------------------------------------
# Overloading
#------------------------------------------------------------------------------------------------

class TwittererRedux
{
  # Create a property
  [string]$TwitterHandle

  # Create a property and set a default value
  [string]$Name = 'Robert C. Cain'

  # Static Properties
  static [string] $Version = '2022.01.07.002'

  # Function that returns a string
  [string] TwitterURL()
  {
    $url = "https://twitter.com/$($this.TwitterHandle)"
    return $url
  }

  # Overloaded Function that returns a string
  [string] TwitterURL($twitterHandle)
  {
    $this.TwitterHandle = $twitterHandle
    $url = $this.TwitterURL()
    return $url
  }

  # Function that has no return value
  [void] OpenTwitter()
  {
    Start-Process $this.TwitterURL()
  }

  # Can launch a twitter page without instantiating the class
  static [void] OpenTwitterPage([string] $TwitterHandle)
  {
    # Note here we cannot call the $this.TwitterUrl function
    # because no object exists (hence no $this)
    $url = "http://twitter.com/$($TwitterHandle)"
    Start-Process $url
  }

}

# Create a new instance
$twit = [TwittererRedux]::new()

# Assign the handle, then call TwitterURL
$twit.TwitterHandle = 'ArcaneCode'
$twit.TwitterURL()

# Now call the overloaded version
$twit.TwitterURL('N4IXT')

$twit.TwitterHandle

#------------------------------------------------------------------------------------------------
# Overload by Type
#------------------------------------------------------------------------------------------------

class over
{
  [string] hello()
    { return 'hello world' }

  [string] hello([string] $name)
    { return "hello string of $name"}

  [string] hello([int] $number)
    { return "hello integer of $number"}
}

$o = [over]::new()

$o.hello()
$o.hello('mom')
$o.hello(33)
