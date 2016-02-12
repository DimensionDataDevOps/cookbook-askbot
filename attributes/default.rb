# default info
default['askbot']['admins'] = "admin@domain.com"
default['askbot']['fremail'] = "admin@domain.com"
default['askbot']['smtp'] = "smtphost.domain.com"

# Default environment
default['askbot']['environment'] = "askbot_testing"

# Default to clone from github.com and master branch
default['askbot']['git']['dir'] = '/opt/askbot'
default['askbot']['git']['repository'] = 'https://github.com/ASKBOT/askbot-devel.git'
default['askbot']['git']['revision'] = 'master'

# Defines default install dir; depends on environment ( dev/prod). Default 'dev'
default['askbot']['install']['dir'] = "/srv/#{node['askbot']['environment']}"

# Default Postgresql values
default['askbot']['db']['name'] = "askbotdb"
default['askbot']['db']['user'] = "askbotusr"
default['askbot']['db']['passwd'] = "askbotpass123"
default['askbot']['db']['host'] = "127.0.0.1"
default['askbot']['db']['port'] = nil

# Default value when deploying mathjax
# Disabled by default
# Override values in recipe to wherever it applies
#default['mathjax']['enabled'] = false
default['mathjax']['git']['dir'] = "/opt/mathjax"
default['mathjax']['git']['repository'] = "git://github.com/mathjax/MathJax.git"
default['mathjax']['git']['revision'] = "master"

# Default solr version and url
#default['solr']['enabled'] = false
default['solr']['serverip'] = "localhost"
default['solr']['port'] = "8983"

# Default haystack value == disabled; override with role/environment
#default['haystack']['enabled'] = false


