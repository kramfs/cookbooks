maintainer       "Chris Fordham"
maintainer_email "chris@xhost.com.au"
license          "Apache 2.0"
description      "Installs/Configures rubygems"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "rubygems::default", "Installs RubyGems"

attribute "ruby/install_source",
  :display_name => "Ruby Install Source",
  :description => "The install source for Ruby: none, ruby1.9.1 or package (default: package).",
  :choices => [ "package", "ruby1.9.1", "none" ],
  :recipes => [ "rubygems::default" ]

 attribute "rubygems/gems_install",
  :display_name => "RubyGems Install",
  :description => "An array or string of RubyGems to install system wide.",
  :recipes => [ "rubygems::gems_install" ]