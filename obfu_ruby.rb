require 'hieroglyphy'

#
# print debugging and error messages
#
def bug(msg)
	$stderr.puts("[*] #{msg}")
end



#
# print usage
#
def usage
    puts "[!] Usage: #{$0} [script <file>| number <number>| string <string>"
    puts "[!] Examples:"
    puts "\t script file.js"
    puts "\t string \"alert('xss')\""
    puts "\t number 1337"
end

# 
# write obfu'd code to disk wrapped in html
#
# this isn't documented in usage yet
def write_html_to_disk(js)
	html = <<-HTML
	<html>
	<body>
	<script language='javascript'>
	#{js}
	</script>
	</body>
	</html>
	HTML

	begin
		f = File.open(ARGV[1].sub(/js$/,"html"), "wb")
		f.write(html)
    rescue IOError => e
		puts "Error writing file (#{e.to_s})"
	ensure
		f.close if f
	end
end

#
# Show obfu'd code, original and new lengths, and inflation rate
#
def show(orig,obfu,orig_wo_comments=nil)
	bug "Obfuscated code follows:"
	puts obfu
	orig = orig.length unless orig.class == Fixnum
	obfu = obfu.length unless obfu.class == Fixnum
	orig_wo_comments = orig unless orig_wo_comments
	orig_wo_comments = orig_wo_comments.length unless orig_wo_comments.class == Fixnum
	bug "Original length:  #{orig}, len w/o comments: #{orig_wo_comments} obfu len: #{obfu})"
	bug "Inflation:  #{inflation(orig_wo_comments,obfu).to_s}x"
end

#
# calculate inflation
#
def inflation(orig,obfu)
	orig = orig.length unless orig.class == Fixnum
	obfu = obfu.length unless obfu.class == Fixnum
	rate = obfu/orig
end

# this is currently not documented in usage
write_html = false
if ARGV.delete("html")
	write_html = true
end

if ARGV.length == 2
	case ARGV[0]
	when 'script'
		begin
			f = File.open(ARGV[1], "rb")
			js = f.read
			o = JSObfu.new(js.strip)
			orig_wo_comments = o.to_s
			write_html ? write_html_to_disk(o.obfuscate) : show(js,o.obfuscate,orig_wo_comments)
        rescue IOError => e
			puts "Error reading file (#{e.to_s})"
		ensure
			f.close if f
		end
	when 'number'
		n = ARGV[1].to_i
		bug "Obfuscating the following which has length:#{n.to_s.length}\n==> #{n.to_s}"
		o = JSObfu.new(n)
		show(js,o.obfu_num)
	when 'string'
		s = ARGV[1].to_s
		bug "Obfuscating the following which has length:#{s.length}\n==> #{s}"
		o = JSObfu.new(s)
		show(js,o.obfu_str)
    else
		print "[!] Unknown command(#{ARGV[0]})"
		usage;exit 1
	end
else
	usage;exit 1
end



