# Sermon Book Builder #

A collection of Rake tasks and tiny scripts that:

1. Cleans HTML exported from LibreOffice.
2. Fetches biblical passages.
3. Combines them into a single book.
4. Converts to PDF.

This code works for me, but may not work for you. Also, it cuts a lot of
corners, doesn't quite bootstrap itself, and in general is only useful as a
proof of concept. Caveat hacker. That said, drop me message if you have any
ideas for improvement or are trying to adapt it for any reason.

## Structure of HTML ##

The choices for formatting HTML are pretty limited right now. Here are some
pieces of meta-data that you can embed in the HTML.

### Sermon Title ###

This will become the chapter header (which will automatically be added to the
ToC)

```html
<title>My Title</title>
```

### Passage ###

Optionally, if there's a passage associated with the sermon, add this meta tag.
It downloads passages from biblegateway.com and their passage parser seems to be
pretty generous. It'll handle simple ranges ("John 3:16-18") or discontinuous
ones ("John 3:16-18, 22-23") and whitespace doesn't seem to matter there. It's
hard-coded to New Revised Standard Version, but you could change it easily if
you figure out the codes for other versions.

I'm not sure what they're terms of use say about this, but I think it's safe to
say "Don't be a jerk with our free service" is one of them. The downloader is
serial and not terribly aggressive, so I don't think it adds anymore load than
a normal web visit would. That said, put a ```sleep``` in somewhere if you're going
to be downloading a couple hundred at a time.

```html
<meta name="CLASSIFICATION" content="John 3:16,xx-yy"/>
```

Any description that doesn't have a ":" is not fetched. This was a hack to work
around some whackiness in more source files and may not apply to you, but it
seems like a simple, if incomplete, well-formedness check.

### Place and Time ###

The output HTML has a place for zero-or-more place and time marks. The content
of this meta tag is split by "\n", then split by comma (which could be a
problem, depending on how you format you dates or if your place has a comma).

```html
<meta name="DESCRIPTION" content="St. Foobar's, 9/15/2013
St. Bazquux's, 9/22/2013">
```

## LibreOffice ##

It's worth noting that LibreOffice allows you to set properties that will end up
in these tags (I originally tried this with its Custom Properties, but I found
that it was inconsistent in which ones it exported to HTML).

Go to File -> Properties. Title becomes <title></title>. Subject becomes CRITERIA.
Comments becomes DESCRIPTION.

## File Placement and Naming ##

Place source files in ./src, and choose names that will cause them to be listed
in order. In my case, I prefixed each name with a two-digit, 0-padded sort
order.

```
00-first.html
01-second.html
...
```

## Technologies Used ##

* [PrinceXML](http://princexml.com) I first used this CSS3 Print renderer back
	in 2006 and it's only gotten better. Back then, it was the only way I had to
	get access to all of that futuristic CSS3 stuff. Now, browsers have caught up
	in a lot of ways (even their "Print" functions have gotten better), but Prince
  is still great for rendering book-scale PDFs. Unfortunately, it doesn't output
  PDF/X-3:2002, which is what a look of print-on-demand companies seem to
  require. That's an open problem I'm dealing with right now.
* [Nokogiri](http://nokogiri.org/) If you've done any HTML scraping in Ruby,
	you've probably used this,
* [Rake](http://rake.rubyforge.org/) If you've done anything in Ruby you've
	probably used this. However, you may not have used its FileTasks before. It's
	pretty powerful, although I have had many problems ensuring that they fire
	when necessary.
* [Haml](http://haml.info/) I could've used Erb. But I like Haml.

You'll need all of these installed. Prince has a demo version that installs a
commandline utillity. Gem install rake, nokogiri, and haml into whatever your
current ```ruby``` points to (TODO: Gemfile...).

### Other Acknowledgements ###

* CSS is forked from the boom.css stylesheet [linked from the Prince
	samples](http://people.opera.com/howcome/2005/ala/boom.css)

## License ##

Copyright (c) 2013 Andrew O'Brien

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

The Software shall be used for Good, not Evil.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
