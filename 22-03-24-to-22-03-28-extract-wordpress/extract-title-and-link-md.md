# Fun With PowerShell - Extracting Blog Titles and Links from a Wordpress Blog with PowerShell - Generating Markdown

## Introduction

In my previous blogpost, [Fun With PowerShell - Extracting Blog Titles and Links from a Wordpress Blog with PowerShell](https://arcanecode.com/2022/03/24/fun-with-powershell-extracting-blog-titles-and-links-from-a-wordpress-blog-with-powershell/), I described how I extracted the title, link, and publication date for posts in my Wordpress blog using PowerShell. I then went on to use PowerShell to generate HTML code that I could insert into a post, or create a basic webpage.

It would also be useful to generate Markdown, instead of HTML, in case I want to use it somewhere such as my [GitHub page](https://github.com/arcanecode). In this post we'll see how to do just that, and create Markdown from the output array of PSCustomObjects.

For all of the examples we'll display the code, then (when applicable) under it the result of our code. In this article I'll be using PowerShell Core, 7.2.2, and VSCode. The examples should work in PowerShell 5.1 in the PowerShell IDE, although they've not been tested there.

Additionally, be on the lookout for the backtick \` , PowerShell's _line continuation_ character, at the end of many lines in the code samples. The blog formatting has a limited width, so using the line continuation character makes the examples much easier to read. My post [Fun With PowerShell Pipelined Functions](https://arcanecode.com/2021/09/13/fun-with-powershell-pipelined-functions/) dedicates a section to the line continuation character if you want to learn more.

To run a snippet of code highlight the lines you want to execute, then in VSCode press F8 or in the IDE F5. You can display the contents of any variable by highlighting it and using F8/F5.

## Where to Start

Much of the work has already been done in the [previous post](https://arcanecode.com/2022/03/24/fun-with-powershell-extracting-blog-titles-and-links-from-a-wordpress-blog-with-powershell/). Review it, stopping at the **Creating HTML** section. The array we created will now be used in generating Markdown.

This is the reason I created an array of custom objects holding the title, link, and publication date. Just as I used it to create HTML, I can now use it to generate Markdown.

## Generating Markdown

Like I did with the HTML, I created a function to create Markdown. This is and advanced function that I'll pipeline the array of PSCustomObjects into.

``` powershell
function Get-WPMarkdown()
{
  [CmdletBinding()]
  param (
          [Parameter (ValuefromPipeline)] $wpObjects
        , [switch] $FormatAsTable
        )

  process
  {
    # Create a formatted output line
    if (!$FormatAsTable.IsPresent)
    {
      # Create each line as a paragraph
      $outLine = @"
$($wpObjects.PubDate) - [$($wpObjects.Title)]($($wpObjects.Link))
"@
    }
    else
    {
      # Create each line as a row in a table
      $outLine = @"
|$($wpObjects.PubDate)|[$($wpObjects.Title)]($($wpObjects.Link))|
"@
    }

    # Return the formatted line
    $outLine
  }

}
```

The first parameter accepts the custom objects we generated from the pipeline. The second is a switch that will format the output as a row in a Markdown table, as opposed to just a line of Markdown text.

I then check to see if the switch was passed in, and format the line to return accordingly. Finally I send the generated line out of the function.

## Using the Get-WPMarkdown Function

Now all we have to do is call the function. As a reminder, the data in the `$outData` variable is the array of custom objects we generated in the previous posts.

``` powershell
$outMd = $outData | Get-WPMarkdown

$wpOutputMd = 'D:\OneDrive\BlogPosts\Markdown\arcanecode.wordpress2.md'
Out-File -FilePath $wpOutputMd -InputObject $outMd -Force
```

This will generate our data as rows in a Markdown file. Below is a small example.

```
2020-09-29 - [VSCode User Snippets for PowerShell and MarkDown](https://arcanecode.com/2020/09/29/vscode-user-snippets-for-powershell-and-markdown/)
2020-12-05 - [Two New PowerShell Courses for Developers on Pluralsight](https://arcanecode.com/2020/12/05/two-new-powershell-courses-for-developers-on-pluralsight/)
2020-12-14 - [Iterate Over A Hashtable in PowerShell](https://arcanecode.com/2020/12/14/iterate-over-a-hashtable-in-powershell/)
```

## Outputting a Markdown Table

In the code there was a switch to format the output Markdown as a table.

``` powershell
$outMd = $outData | Get-WPMarkdown -FormatAsTable
```

As I did with the HTML example, I wanted to wrap the generated data in the appropriate Markdown code to make this a complete Markdown table. I created another function to handle this.

``` powershell
function Add-WPMarkdownHeader()
{
  [CmdletBinding()]
  param (
          [Parameter (Mandatory = $true)]
          $markdownData
        )

  # Create a new array
  $outTable = @()

  # Add the html to create a left aligned table header
  $outTable += '|Date|Post|'
  $outTable += '|:-----|:-----|'

  # Add the existing table row data
  foreach ($row in $markdownData) { $outTable += $row }

  # Return the output
  return $outTable
}
```

As you can see, it creates a new array, adding the Markdown code for a table header, one specific for our data. It then cycles through the array that was passed in and adds it to the new array. Once done this new array is returned by the function.

To call it we simply use the following sample to write it to a file.

``` powershell
$outTable = Add-WPMarkdownHeader $outMd
Out-File -FilePath $wpOutputMd -InputObject $outTable -Force
```

Here is a sample of the output.

```
|Date|Post|
|:-----|:-----|
2020-09-29 - [VSCode User Snippets for PowerShell and MarkDown](https://arcanecode.com/2020/09/29/vscode-user-snippets-for-powershell-and-markdown/)
2020-12-05 - [Two New PowerShell Courses for Developers on Pluralsight](https://arcanecode.com/2020/12/05/two-new-powershell-courses-for-developers-on-pluralsight/)
2020-12-14 - [Iterate Over A Hashtable in PowerShell](https://arcanecode.com/2020/12/14/iterate-over-a-hashtable-in-powershell/)
```

## Conclusion

In this post we saw how to generate Markdown code from a Wordpress blog extract. Combined with the code in my previous post I now have a handy script I can use to generate HTML and Markdown code from my blog posts. This will be handy for both now, and when I want to create wrap up posts for future series.

These techniques can be easily adapted for any XML file that you wish to create a summary listing for, in HTML or Markdown or both.

The demos in this series of blog posts were inspired by my Pluralsight course [PowerShell 7 Quick Start for Developers on Linux, macOS and Windows](https://pluralsight.pxf.io/jWzbre), one of many PowerShell courses I have on Pluralsight. All of my courses are linked on my [About Me](https://arcanecode.com/info/) page.

If you don't have a Pluralsight subscription, just go to [my list of courses on Pluralsight](https://pluralsight.pxf.io/kjz6jn) . At the top is a Try For Free button you can use to get a free 10 day subscription to Pluralsight, with which you can watch my courses, or any other course on the site.
