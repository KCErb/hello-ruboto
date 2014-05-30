require 'github/markup'

file = 'lesson1.md'
res = GitHub::Markup.render(file,File.read(file))
res.gsub!("<pre lang=\"ruby\"><code>","[sourcecode language=\"ruby\"]")
res.gsub!("</code></pre>","[/sourcecode]")
File.open('lesson1.html', 'w') { |file| file.write(res) }
