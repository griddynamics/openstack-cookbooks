maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures nova"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3"

depends "apt"
#depends "build-essential"
depends "mysql"
#depends "openldap"
depends "openssl"
depends "rabbitmq", "> 1.2" 
#depends "runit"
