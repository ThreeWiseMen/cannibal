require "rake"

require "rake/gempackagetask"
require "rspec/core/rake_task"
require "cucumber/rake/task"

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:cucumber)

spec = Gem::Specification.new do |s|
	s.platform          = Gem::Platform::RUBY
        s.name              = "cannibal"
        s.version           = "0.5.0"
        s.author            = "Three Wise Men"
        s.email             = "info @nospam@ threewisemen.ca"
        s.summary           = "Permission framework for Ruby objects"
        s.description       = "Use this library in a Ruby application to provide permission declaration and querying capabilities between Ruby objects."
        s.files             = FileList[ 'lib/*.rb', 'lib/cannibal/*.rb' ].to_a
        s.require_path      = "lib"
        s.has_rdoc          = true
        s.extra_rdoc_files  = ["README.mdown"]
end

Rake::GemPackageTask.new(spec) do |pkg|
	pkg.need_tar = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
	puts "generated latest version"
end

