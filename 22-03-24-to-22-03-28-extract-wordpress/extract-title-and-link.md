# Fun With PowerShell - Extracting Blog Titles and Links from a Wordpress Blog with PowerShell

## Introduction

Since September of 2020 I have been blogging heavily on PowerShell. In a few posts I'm going to start a new series on a different subject, but first I wanted to provide a wrap up post with links to all my recent PowerShell posts.

Extracting all of those titles and links by hand seemed like a labor intensive task, so of course I wanted to automate it. In addition, I'll be able to reuse the code when I'm ready to wrap up my next, or a future, series.

My blog is hosted on Wordpress.com, which provides an export function. In this post I'll cover the code I created to extract all my links, and how I generated HTML from it. In my next post I'll show the same methodology for generating Markdown, and in the next post will do the PowerShell roundup.

For all of the examples we'll display the code, then (when applicable) under it the result of our code. In this article I'll be using PowerShell Core, 7.2.2, and VSCode. The examples should work in PowerShell 5.1 in the PowerShell IDE, although they've not been tested there.

Additionally, be on the lookout for the backtick \` , PowerShell's _line continuation_ character, at the end of many lines in the code samples. The blog formatting has a limited width, so using the line continuation character makes the examples much easier to read. My post [Fun With PowerShell Pipelined Functions](https://arcanecode.com/2021/09/13/fun-with-powershell-pipelined-functions/) dedicates a section to the line continuation character if you want to learn more.

To run a snippet of code highlight the lines you want to execute, then in VSCode press F8 or in the IDE F5. You can display the contents of any variable by highlighting it and using F8/F5.

## Extracting Data from Wordpress

One of the administrator tools in the Wordpress.com site is the ability to extract your blog. You can generate an XML file with the entire contents of your blog. This includes all of the data including the post itself, comments, and associated metadata. They do provide the ability to limit the extract by by date range and subjects.

As you can guess this extract file is large, far too much to sift through by hand. That's where PowerShell came to my rescue!

For each post, the exported XML file has three lines we are interested in, the tags with `<title>`, `<pubDate>` and `<link>`. I tackled this in stages.

As the first stage, I simply loop over the data in the file, looking for the XML tags I need. When I've found all three, I have a small function that creates a PowerShell custom object. After each object is created, it is added into an array. I needed to do a little filtering, as over the last year I've added a few more blog posts on other topics. I did not want these to be included in my future "Fun With PowerShell Roundup" post.

Once I have an array of custom objects, I can easily use them in multiple scenarios. For generating HTML I created a function that takes each object and generates a line of HTML code. It also has a way to generate the line as an HTML row instead of a series of paragraphs.

For my purposes, this was all I needed. However there may be times when you wish to generate a complete, but basic, web page. There is one more function I created that will take the output of the HTML rows and add the lines needed to make it a valid HTML page.

## Generating a Custom Wordpress Object

I mentioned a function to create a custom object, so let's start with that.

``` powershell
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
```

The function is straightforward, it takes the three passed in parameters and creates a custom object from it. This is a common technique, it allows you to easily generate a custom object. It also leverages code reuse.

If you want to get a more detailed explanation on creating and using custom PowerShell objects, see my post [Fun With PowerShell Objects - PSCustomObject](https://arcanecode.com/2022/01/10/fun-with-powershell-objects-pscustomobject/).

## Creating The Array

Before we create the array, we need to read in the data from the Wordpress XML extract file. I create a variable to hold the location, then read it in.

``` powershell
$wpInput = 'D:\OneDrive\BlogPosts\Markdown\arcanecode.wordpress.2022-03-08.000.xml'

# Read the data from input file
$inData = Get-Content $wpInput
```

Now it's time to read in the data from the XML file, one line at a time.

``` powershell
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
```

First I create an empty array that will hold the output. To learn more about arrays, see my post [Fun With PowerShell Arrays](https://arcanecode.com/2021/07/26/fun-with-powershell-arrays/).

Now I enter a `foreach` loop, to go over each line in the array. If you don't know, when you use `Get-Content` it returns each line in the file as a row in an array. That's what I want here, but be aware if you add the `-Raw` switch to the `Get-Content` it returns the entire file as one big text string.

The data in the XML occurs in the order of Title, Link, then PubDate. PubDate is the Publication Date for the blog post.

As I find the title and link, I remove the XML tags then copy the data into a local variable. For some reason the extract uses http for the links, so I wanted to correct it to use https.

When I find the PubDate, I wanted to reformat it as a string in YYYY-MM-DD format. I extract just the date portion of the line by removing the XML tags. I then cast it to a `[DateTime]` and store it in a temporary variable.

I can then call the `ToString` method of the DataTime datatype to format it in a format I want, namely YYYY-MM-DD (Year, Month, Day).

Next I check to see if the title contains the word PowerShell. If so, I now have the three pieces of info I need, and call my function to generate the PSCustomObject and add it to the output array.

## Creating HTML

To create the HTML I wrote a function, `Get-WPHtml`. Like the other functions I created this as an Advanced function. To read up on Advanced Functions, see my article [Fun With PowerShell Advanced Functions](https://arcanecode.com/2021/09/06/fun-with-powershell-advanced-functions/).

I needed this so I could pipe the data from the array containing my Wordpress PSCustomObjects into it. By doing it this way, I could reuse the `Get-WPHtml` with any array that has objects with three properties of Title, Link, and PubDate.

Let's look at the function.

``` powershell
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
```

The first parameter will accept the data from our pipeline, as I explain in my article [Fun With PowerShell Pipelined Functions](https://arcanecode.com/2021/09/13/fun-with-powershell-pipelined-functions/). Next is an optional parameter that allows the user to indent each row a certain number of spaces. The final parameter toggles between formatting each row as a standard paragraph or as a table row.

The process block will run once for each piece of data passed in from the pipeline. It creates a variable with the number of spaces the user indicated. If the user didn't pass a value in, this will wind up being an empty string.

Next we check to see if the switch `FormatAsTable` was passed in, then create an output string based on the users choice. For more on switches, refer to my article [Fun With the PowerShell Switch Parameter](https://arcanecode.com/2021/09/20/fun-with-the-powershell-switch-parameter/).

As a final step we return the newly formatted line, which puts it out to the pipeline.

## Using the New Function

Using these functions is easy. We take the array of custom objects, then pipe it into the new Get-WPHtml function using an indent of 2. The result is copied into the `$outHtml` variable which will be an array.

Finally we set the path for our output file, then use the `Out-File` cmdlet to write to disk.

``` powershell
$outHtml = $outData | Get-WPHtml -Indent 2

# Save the new array to a file. Use Force to overwrite the file if it exists
$wpOutputHtml = 'D:\OneDrive\BlogPosts\Markdown\arcanecode.wordpress2.html'
Out-File -FilePath $wpOutputHtml -InputObject $outHtml -Force
```

## Creating a Full HTML Page

For my purposes, I am going to take the data in the file and copy and paste it into the Wordpress post editor when I create my roundup blog post. For testing purposes, however, it was convenient to have a full webpage. With a full webpage I can open it in a web browser, see the result, and test it out. Further, in other projects I may actually need a full webpage and not the part of one that I'll be using for my blog.

The version of the webpage with just paragraph tags will open OK in a browser, but the version of the table will not. So let's fix that.

Here is the function I created to wrap the output of the previous function, when called using the `-FormatAsTable` flag, in the necessary HTML to make it a functioning webpage.

``` powershell
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
```

The one parameter is the array that was output from our `Get-WPHtml` function. While you can add rows to an array, or change values at a specific position, you can't insert new rows at specific positions. As such we have to create a new empty array, which was done with `$outTable`.

We then add the lines needed to create the table header. For this article I'm assuming you are familiar with basic HTML tags.

Once the header rows have been added we cycle through the input array, adding each row to the new output array.

Finally we add the closing tag to finish off the table element, then return the output.

## Generating the Complete Webpage

Now that the hard part is done, all we have to do is call the function, passing in the output of the previous function, stored in `$outHtml`. This will then be written to a file using the `Out-File` cmdlet.

``` powershell
$outTable = Add-WPHtmlHeader $outHtml

# Save the new array to a file. Use Force to overwrite the file if it exists
Out-File -FilePath $wpOutputHtml -InputObject $outTable -Force
```

## The Output

Here is a sample of the output of our hard work. Note I've only included a few rows of blog posts to keep it brief.

```
<style>th { text-align: left; } </style>
<table>
<tr>
<th>Date</th> <th>Post</th>
</th>
  <tr> <td>2020-09-29</td> <td><a href="https://arcanecode.com/2020/09/29/vscode-user-snippets-for-powershell-and-markdown/" target=blank>VSCode User Snippets for PowerShell and MarkDown</a></td> </tr>
  <tr> <td>2020-12-05</td> <td><a href="https://arcanecode.com/2020/12/05/two-new-powershell-courses-for-developers-on-pluralsight/" target=blank>Two New PowerShell Courses for Developers on Pluralsight</a></td> </tr>
  <tr> <td>2020-12-14</td> <td><a href="https://arcanecode.com/2020/12/14/iterate-over-a-hashtable-in-powershell/" target=blank>Iterate Over A Hashtable in PowerShell</a></td> </tr>
</table>
```

## Conclusion

In this post we tackled a project to create an HTML page based on the export of a Wordpress blog. In the process we used many of the techniques I've blogged about over the last year and a half.

For the next post we'll use these same techniques to create an output file in Markdown format.

The demos in this series of blog posts were inspired by my Pluralsight course [PowerShell 7 Quick Start for Developers on Linux, macOS and Windows](https://pluralsight.pxf.io/jWzbre), one of many PowerShell courses I have on Pluralsight. All of my courses are linked on my [About Me](https://arcanecode.com/info/) page.

If you don't have a Pluralsight subscription, just go to [my list of courses on Pluralsight](https://pluralsight.pxf.io/kjz6jn) . At the top is a Try For Free button you can use to get a free 10 day subscription to Pluralsight, with which you can watch my courses, or any other course on the site.

https://arcanecode.com/2022/03/24/fun-with-powershell-extracting-blog-titles-and-links-from-a-wordpress-blog-with-powershell/
