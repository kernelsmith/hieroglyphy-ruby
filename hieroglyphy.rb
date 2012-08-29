class JSObfu
	# This ruby code was ported from the resources below

	# Copyright (c) <2012> <Patricio Palladino>
	# Hieroglyphy, Python port from JavasCript version by <Patricio Palladino>
	# alcuadrado@github ~ mattaereal@github

	# Permission is hereby granted, free of charge, to any person obtaining a copy of
	# this software and associated documentation files (the "Software"), to deal in
	# the Software without restriction, including without limitation the rights to
	# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
	# the Software, and to permit persons to whom the Software is furnished to do so,
	# subject to the following conditions:

	# The above copyright notice and this permission notice shall be included in all
	# copies or substantial portions of the Software.

	# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
	# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
	# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
	# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
	# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	def initialize(code,strip_c=true)
		@code = code
		strip_comments! if strip_c
		init_char_set
	end

	#
	# returns the obfuscated javascript
	#
	def obfuscate
		return transform_script(@code)
	end

	# Testing
	def obfu_num
		return transform_number @code
	end
	def obfu_str
		return transform_string @code
	end

	#
	# provide a to_s method
	#
	def to_s
		@code
	end
	#
	# Removes comments and blank lines.  Call before obfuscation
	#
	def strip_comments!
		@code = strip_comments
	end

	#
	# Removes comments and blank lines.  Call before obfuscation
	#
	def strip_comments
		# removes whole lines only, doesn't remove inline comments
		code_to_be_obfu = ''
		@code.each_line do |line|
			if (not line =~ /^\s*\/\// and not line =~ /^\s+$/)
				code_to_be_obfu << line 
			end
		end
		return code_to_be_obfu
	end

	protected

	#
	# get the hex string of +number+ padded by zeroes to reach +digits+ if necessary
	#
	def get_hex_string (number, digits)
		str = ""
		begin
        	str = number.to_s(16)
        rescue Exception => e
        	# for now just re-raise the error, this is here in case we want to do something else instead
        	raise e
        end
       	return str.rjust(digits,"0")
    end

    #
    # returns an unescape sequence for a given +charcode+ aka a codepoint
    #
    def get_unescape_sequence(charcode)
    	return @kw[:unescape] + "(" + transform_string("%" + get_hex_string(charcode, 2)) + ")"
    end

    #
    # returns a hex sequence for a given +charcode+ aka a codepoint
    #
	def get_hex_sequence(charcode)
		return transform_string( "\\x" + get_hex_string(charcode, 2) )
	end

	#
	# returns a unicode sequence for a +charcode+
	#
	def get_unicode_sequence (charcode)
		return transform_string( "\\u" + get_hex_string(charcode, 4) )
	end

	#
	# returns a hieroglyphied (obfuscated) +char+
	#
	def transform_char(char)
		# if we already know about char, just look it up and return it obfu'd.
		if @characters.include?(char)
			return @characters[char]
		end
		charcode = char.bytes.first #char[0].ord # this works in Ruby 1.8 and 1.9, nice.
		if (char == "\\" or char == "x")
			# These chars must be handled apart because the others need them
			@characters[char] = get_unescape_sequence(charcode)
			return @characters[char]
		end

		shortest_sequence = get_unicode_sequence(charcode)

		# ASCII@characters can be obtained with hexa and unscape sequences
		if (charcode < 128)
			unescape_sequence = get_unescape_sequence(charcode)
			if (shortest_sequence.length > unescape_sequence.length)
				shortest_sequence = unescape_sequence
			end

			hex_sequence = get_hex_sequence(charcode)
			if (shortest_sequence.length > hex_sequence.length)
				shortest_sequence = hex_sequence
			end
		end

		@characters[char] = shortest_sequence
		return shortest_sequence
	end

	#
	# returns a hieroglyphied (obfuscated) string from +str+
	#
	def transform_string(str)
		glyph_str = ""
		str.each_char do |c|
			glyph_str += "+" unless glyph_str == ""
			glpyh_char = transform_char(c)
			glyph_str += glpyh_char
		end
		return glyph_str
	end

    #
    # Returns a hieroglyphied (obfuscated) number +n+
    #
    def transform_number(n)
        return @numbers[n] if n <= 9
        return "+(" + transform_string(n.to_s) + ")"
    end

    #
	# Returns a hieroglyphied (obfuscated) script from +src+
	#
    def transform_script(src)
        return (@kw[:function_constructor] + "("  + transform_string(src) + ")()")
    end

	protected

	def init_char_set
		@numbers = [
			"+[]",											# 0
			"+!![]",
			"!+[]+!![]",
			"!+[]+!![]+!![]",
			"!+[]+!![]+!![]+!![]",
			"!+[]+!![]+!![]+!![]+!![]",						# 5
			"!+[]+!![]+!![]+!![]+!![]+!![]",
			"!+[]+!![]+!![]+!![]+!![]+!![]+!![]",
			"!+[]+!![]+!![]+!![]+!![]+!![]+!![]+!![]",
			"!+[]+!![]+!![]+!![]+!![]+!![]+!![]+!![]+!![]"	# 9
			]
		@characters = {
			"0" => "(" + @numbers[0] + "+[])",
			"1" => "(" + @numbers[1] + "+[])",
			"2" => "(" + @numbers[2] + "+[])",
			"3" => "(" + @numbers[3] + "+[])",
			"4" => "(" + @numbers[4] + "+[])",
			"5" => "(" + @numbers[5] + "+[])",
			"6" => "(" + @numbers[6] + "+[])",
			"7" => "(" + @numbers[7] + "+[])",
			"8" => "(" + @numbers[8] + "+[])",
			"9" => "(" + @numbers[9] + "+[])"
			}

		# keywords
		@kw = {
			:_object_Object	=> '{}+[]',
			:_NaN			=> '+{}+[]',
			:_true			=> '!![]+[]',
			:_false			=> '![]+[]',
			:_undefined		=> '[][+[]]+[]'
			}
		@characters[" "] = "(" + @kw[:_object_Object] + ")[" + @numbers[7]  + "]"
		@characters["["] = "(" + @kw[:_object_Object] + ")[" + @numbers[0]  + "]"
		@characters["]"] = "(" + @kw[:_object_Object] + ")[" + @characters["1"] + "+" + @characters["4"] + "]"
		@characters["a"] = "(" + @kw[:_NaN] + ")[" + @numbers[1] + "]"
		@characters["b"] = "(" + @kw[:_object_Object] + ")[" + @numbers[2] + "]"
		@characters["c"] = "(" + @kw[:_object_Object] + ")[" + @numbers[5] + "]"
		@characters["d"] = "(" + @kw[:_undefined] + ")[" + @numbers[2] + "]"
		@characters["e"] = "(" + @kw[:_undefined] + ")[" + @numbers[3] + "]"
		@characters["f"] = "(" + @kw[:_undefined] + ")[" + @numbers[4] + "]"
		@characters["i"] = "(" + @kw[:_undefined] + ")[" + @numbers[5] + "]"
		@characters["j"] = "(" + @kw[:_object_Object] + ")[" + @numbers[3] + "]"
		@characters["l"] = "(" + @kw[:_false] + ")[" + @numbers[2] + "]"
		@characters["n"] = "(" + @kw[:_undefined] + ")[" + @numbers[1] + "]"
		@characters["o"] = "(" + @kw[:_object_Object] + ")[" + @numbers[1] + "]"
		@characters["r"] = "(" + @kw[:_true] + ")[" + @numbers[1] + "]"
		@characters["s"] = "(" + @kw[:_false] + ")[" + @numbers[3] + "]"
		@characters["t"] = "(" + @kw[:_true] + ")[" + @numbers[0] + "]"
		@characters["u"] = "(" + @kw[:_undefined] + ")[" + @numbers[0] +"]"
		@characters["N"] = "(" + @kw[:_NaN] + ")[" + @numbers[0] + "]"
		@characters["O"] = "(" + @kw[:_object_Object] + ")[" + @numbers[8] + "]"
		@kw[:_Infinity] = "+(" + @numbers[1] + "+" +@characters["e"] + "+" +
			@characters["1"] + "+" +@characters["0"] + "+" +@characters["0"] + "+" +@characters["0"] + ")+[]"
		@characters["y"] = "(" + @kw[:_Infinity] + ")[" + @numbers[7] + "]"
		@characters["I"] = "(" + @kw[:_Infinity] + ")[" + @numbers[0] + "]"

		@kw[:_1e100] = "+(" + @numbers[1] + "+" +@characters["e"] + "+" +
			@characters["1"] + "+" +@characters["0"] + "+" +@characters["0"] + ")+[]"
		@characters["+"] = "(" + @kw[:_1e100] + ")[" + @numbers[2] + "]"
		@kw[:function_constructor] = "[][" + transform_string("sort") + "][" + transform_string("constructor") + "]"
		
		# The chars below need target http(s) pages
		@kw[:location_string] = "[]+" + transform_script("return location")
		@characters["h"] = "(" + @kw[:location_string] + ")" + "[" + @numbers[0] + "]"
		@characters["p"] = "(" + @kw[:location_string] + ")" + "[" + @numbers[3] + "]"

		@characters["/"] = "(" + @kw[:location_string] + ")" + "[" + @numbers[6] + "]"

		@kw[:unescape] = transform_script("return unescape")
		@kw[:escape] = transform_script("return escape")

		@characters["%"] = @kw[:escape] + "(" + transform_string("[") + ")[" + @numbers[0] + "]"

		do_full_debug if false
	end
	
	def bug(msg)
		$stderr.puts "[*] #{msg}"
	end
	def do_full_debug
		bug "*************************************"
		bug "NUMBERS (AS INTEGERS)"
		bug "*************************************"
		@numbers.each_with_index do |n,idx|
			$stderr.puts "NUMBER #{idx.to_s} is #{n.to_s} (length=#{n.length})"
		end
		bug "*************************************"
		bug "CHARACTERS"
		bug "*************************************"
		keys = @characters.keys
		keys.sort.each do |key|
			val = @characters[key]
			$stderr.puts "CHAR #{key} is #{val.to_s} (length=#{val.length})"
		end
		bug "*************************************"
		bug "KEYWORDS"
		bug "*************************************"
		keys = []
		@kw.keys.each_with_index do |key, idx|# convert keys to strings so they can be sorted
			keys[idx] = key.to_s
		end
		keys.sort.each do |key|
			val = @kw[key.to_sym]
			$stderr.puts "KEYWORD #{key} is #{val.to_s} (length=#{val.length})"
		end
	end
end # end class

