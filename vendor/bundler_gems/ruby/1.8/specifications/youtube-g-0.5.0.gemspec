# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{youtube-g}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Shane Vitarana", "Walter Korman", "Aman Gupta", "Filip H.F. Slagter"]
  s.date = %q{2009-01-07}
  s.description = %q{An object-oriented Ruby wrapper for the YouTube GData API}
  s.email = %q{ruby-youtube-library@googlegroups.com}
  s.extra_rdoc_files = ["History.txt", "README.txt"]
  s.files = ["History.txt", "lib/youtube_g/client.rb", "lib/youtube_g/logger.rb", "lib/youtube_g/model/author.rb", "lib/youtube_g/model/category.rb", "lib/youtube_g/model/contact.rb", "lib/youtube_g/model/content.rb", "lib/youtube_g/model/playlist.rb", "lib/youtube_g/model/rating.rb", "lib/youtube_g/model/thumbnail.rb", "lib/youtube_g/model/user.rb", "lib/youtube_g/model/video.rb", "lib/youtube_g/parser.rb", "lib/youtube_g/record.rb", "lib/youtube_g/request/base_search.rb", "lib/youtube_g/request/standard_search.rb", "lib/youtube_g/request/user_search.rb", "lib/youtube_g/request/video_search.rb", "lib/youtube_g/request/video_upload.rb", "lib/youtube_g/response/video_search.rb", "lib/youtube_g.rb", "Manifest.txt", "README.txt", "test/test_client.rb", "test/test_video.rb", "test/test_video_search.rb", "TODO.txt", "youtube-g.gemspec"]
  s.homepage = %q{http://youtube-g.rubyforge.org/}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{An object-oriented Ruby wrapper for the YouTube GData API}
  s.test_files = ["test/test_client.rb", "test/test_video.rb", "test/test_video_search.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
