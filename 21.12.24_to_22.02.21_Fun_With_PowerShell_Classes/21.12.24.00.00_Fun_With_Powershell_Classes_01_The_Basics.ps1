## A Very Simple Class
<#
class Twitterer
{
  # Create a property
  [string]$TwitterHandle

}
#>

<#
class Twitterer
{
  # Create a property
  [string]$TwitterHandle

  # Create a property and set a default value
  [string]$Name = 'Robert C. Cain'
}

$twit = [Twitterer]::new()

# See default property value
$twit.Name

# Override default value
$twit.Name = 'Mr. Code'
$twit.Name
#>

<#
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

}

$twit = [Twitterer]::new()
$twit.TwitterHandle = 'ArcaneCode'
$myTwitter = $twit.TwitterURL()
$myTwitter

$twit.OpenTwitter()
#>


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

$twit = [Twitterer]::new()
$twit.TwitterHandle = 'ArcaneCode'
$twit.OpenTwitter()

