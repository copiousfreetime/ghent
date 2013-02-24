# vim: syntax=ruby
load 'tasks/this.rb'

This.name     = "ghent"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "http://github.com/copiousfreetime/#{ This.name }"

This.ruby_gemspec do |spec|
  spec.add_dependency( 'json', '~> 1.7.7' )
  spec.add_dependency( 'link_header', '~> 0.0.5' )
  spec.add_dependency( 'lru', '~> 0.1.0' )
  spec.add_dependency( 'celluloid', '~> 0.12.4' )
  spec.add_dependency( 'addressable', '~> 2.3' )
  spec.add_dependency( 'netrc', '~> 0.7.7' )
  spec.add_dependency( 'httpclient', '~> 2.3' )
  spec.add_dependency( 'logging', '~> 1.8.1' )
  spec.add_dependency( 'kjess', '~> 1.1.0' )
  spec.add_dependency( 'aws-sdk', '~> 1.8' )

  spec.add_development_dependency( 'rake'     , '~> 10.0.3')
  spec.add_development_dependency( 'minitest' , '~> 4.5.0' )
  spec.add_development_dependency( 'rdoc'     , '~> 3.12'   )

end

load 'tasks/default.rake'
