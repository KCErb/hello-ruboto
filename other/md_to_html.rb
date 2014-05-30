require 'github/markup'

file = 'lesson1.md'
res = GitHub::Markup.render(file,File.read(file))
File.open('lesson1.html', 'w') { |file| file.write(res) }
