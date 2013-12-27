desc "Build directory"
directory "build"

desc "Copy source files"
task :copy => "build"

FileList["src/*"].each do |src|
  target = src.sub("src/", "build/")
  file target => src do
    case File.extname(src)
    when ".html"
      sh %{cat "#{src}" | ruby -rubygems clean_html.rb > "#{target}"}
    else
      cp src, target
    end
  end
  task :copy => target
end

directory "build/passages" => "build"

file :passage_list => ["build/passages", :copy] + FileList["build/*.html"] do
  sh %{cat build/*.html | ruby -rubygems extract_verses.rb > build/passages/list.txt}
end

task :get_passages => :passage_list do
  verses = File.read("build/passages/list.txt")
  verses.split("\n").each do |verse|
    sh %{ruby -rubygems get_verses.rb "#{verse}" > "build/passages/#{verse}.html"}
  end
end

directory "build/front"
task :build_front => "build/front"

file "build/front/toc.html" => ["build/front", :copy] do
  sh %{ruby -rubygems make_toc.rb build/*.html > build/front/toc.html }
end
task :build_front => "build/front/toc.html"

directory "build/chapters"
task :build_chapters => ["build/chapters", :get_passages]

file "build/chapters/book.html" => [:build_chapters, :build_front] do
  sh %{ruby -rubygems make_book.rb build/front/toc.html build/chapters/*.html > build/chapters/book.html}
end

FileList["build/*"].each do |src|
  bname = File.basename(src)
  target = "build/chapters/#{bname}"
  unless File.directory?(src)
    file target => ["build/chapters", src] do
      case File.extname(target)
      when ".html"
        sh %{ruby -rubygems make_chapter.rb "#{src}" > "#{target}"}
      when ".gif"
        cp src, target
      end
    end
    task :build_chapters => target
  end
end

task :prince do
  rm_f "final.pdf"
  sh "prince build/chapters/book.html -s boom.css -o final.pdf"
  sh "open final.pdf"
end

require 'rake/clean'
CLEAN << "build/"
CLOBBER << "final.pdf"
