
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "chkdfront/version"

Gem::Specification.new do |spec|
  spec.name          = 'chkdfront'
  spec.version       = ChkDFront::VERSION
  spec.authors       = ['@KINGSABRI']
  spec.email         = ['king.sabri@gmail.com']

  spec.summary       = %q{Check Domain Fronting (chkdfront) - It checks if domain fronting is working.}
  spec.description   = %q{Check Domain Fronting (chkdfront) - It checks if domain fronting implementation is working.}
  spec.homepage      = 'https://github.com/KINGSABRI/chkdfront'
  spec.licenses      = ['MIT']

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.executables   = ['chkdfront']
  spec.require_paths = ["lib"]

  spec.add_dependency 'cli-ui'
  spec.add_dependency 'tty-spinner'
  spec.add_dependency 'word_wrap'
  spec.add_dependency 'net-ping'
  spec.add_dependency 'net-dns'
  spec.add_dependency 'adomain'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", ">= 12.3.3"


  spec.metadata['source_code_uri'] = 'https://github.com/KINGSABRI/chkdfront'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/KINGSABRI/chkdfront/issues'
end
