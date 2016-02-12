#
# Cookbook Name:: askbot
# Recipe:: default
# Author:: Eugene Narciso (<eugene.narciso@itaas.dimensiondata.com>)
#
# Copyright 2016, Dimension Data Cloud Buisness Unit
#
# All rights reserved - Do Not Redistribute
#

# Repo override
node.override['askbot']['git']['repository'] = "https://github.com/askbot/askbot-devel.git"
node.override['askbot']['git']['revision'] = "develop"

# solr ver override
node.override['solr']['version'] = '3.6.2'
node.override['solr']['checksum'] = "537426dcbdd0dc82dd5bf16b48b6bcaf87cb4049c1245eea8dcb79eeaf3e7ac6"
node.override['solr']['url'] = "http://162.216.171.221/solr/#{node['solr']['version']}/apache-solr-#{node['solr']['version']}.tgz"

# MathJax overrides
node.override['mathjax']['git']['repository'] = 'git@github.com:mathjax/MathJax.git'
node.override['mathjax']['git']['revision'] = 'master'

# Enable features
node.set['solr']['enabled'] = true
node.set['haystack']['enabled'] = true
node.set['mathjax']['enabled'] = true