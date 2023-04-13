

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


$twit = [TwittererRedux]::new('ArcaneCode', 'Mr. Code')

# Show the results
$twit.TwitterHandle
$twit.Name