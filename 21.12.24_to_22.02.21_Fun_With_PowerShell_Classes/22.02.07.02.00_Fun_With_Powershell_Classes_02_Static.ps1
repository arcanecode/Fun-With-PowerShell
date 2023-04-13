#------------------------------------------------------------------------------------------------
# Starting Point
#------------------------------------------------------------------------------------------------
class Twitterer
{
  # Create a property
  [string]$TwitterHandle

  # Create a property and set a default value
  [string]$Name = 'Robert C. Cain'

  # Function that returns a string
  [string] TwitterURL()
  {
    $url = "https://twitter.com/$($this.TwitterHandle)"
    return $url
  }

  # Function that has no return value
  [void] OpenTwitter()
  {
    Start-Process $this.TwitterURL()
  }

}

#------------------------------------------------------------------------------------------------
# Static Properties and Methods
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



#------------------------------------------------------------------------------------------------
# Overloads
#------------------------------------------------------------------------------------------------


<#

class TwittererRedux
{
  # Default Constructor
  TwittererRedux ()
  {
  }

  # Constructor passing in Twitter Handle
  TwittererRedux ([string]$TwitterHandle)
  {
    $this.TwitterHandle = $TwitterHandle
  }

  # Constructor passing in Twitter Handle and Name
  TwittererRedux ([string]$TwitterHandle, [string]$Name)
  {
    $this.TwitterHandle = $TwitterHandle
    $this.Name = $Name
  }

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

  # Overloaded Function that returns a string
  [string] TwitterURL($twitterHandle)
  {
    $url = "http://twitter.com/$($twitterHandle)"
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

#>



#------------------------------------------------------------------------------------------------
# Constructors
#------------------------------------------------------------------------------------------------

<#
class TwittererRedux
{
  # Default Constructor
  TwittererRedux ()
  {
  }

  # Constructor passing in Twitter Handle
  TwittererRedux ([string]$TwitterHandle)
  {
    $this.TwitterHandle = $TwitterHandle
  }

  # Constructor passing in Twitter Handle and Name
  TwittererRedux ([string]$TwitterHandle, [string]$Name)
  {
    $this.TwitterHandle = $TwitterHandle
    $this.Name = $Name
  }

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

  # Overloaded Function that returns a string
  [string] TwitterURL($twitterHandle)
  {
    $url = "http://twitter.com/$($twitterHandle)"
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
#>