# Hieroglyphy

A tool and library for converting javascript strings, numbers, and scripts to
equivalent sequences of ()[]{}+! characters that run in the browser.
(Currently Internet Explorer is only supported if the html keeps the browser in
standards mode, this is most common when the html includes the following strict DOCTYPE
declaration and does not use deprecated elements)
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
(This was tested on IE8 and IE9)

## Usage and installation

You can use the class inside hieroglyphy.rb or use the provided obfu_ruby.rb script
which calls into hieroglyphy.rb and gives you some inflation statistics etc.
Example usage of obfu_ruby.rb:$ obfu_ruby.rb script test.js

## This ruby code was ported from the resources below

Copyright (c) <2012> <Patricio Palladino>
Hieroglyphy, Python port from JavaScript version by <Patricio Palladino>
alcuadrado@github ~ mattaereal@github ~ kernelsmith@github

original blog:  http://patriciopalladino.com/blog/2012/08/09/non-alphanumeric-javascript.html

original js code:  https://github.com/alcuadrado/hieroglyphy

python:  https://github.com/mattaereal/hieroglyphy.py

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
