#
# Cookbook Name:: askbot
# Recipe:: search
# Author:: Eugene Narciso (<eugene.narciso@itaas.dimensiondata.com>)
#
# Copyright 2016, Dimension Data Cloud Buisness Unit
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'solr'
include_recipe 'python::pip'

node['askbot']['solr'['packages'].each do |pkg|
  package pkg
end

solr_instance_name = node['askbot']['environment']
solr_home = "/opt/solr/#{solr_instance_name}"
solr_schema = "#{solr_home}/conf/schema.xml"
solr_xml = "#{solr_home}/solr.xml"
solr_config = "#{solr_home}/conf/solrconfig.xml"

#Install solr related packages if solr == True
if node['solr']['enabled']
  #{"pysolr" => "3.1.0", "lxml" => "3.2.4", "cssselect" => "0.9.1"}.each do |pip,ver|
  #  python_pip pip do
  #    version ver
  #    action :install
	#  end
  #end
  ['pysolr', 'lxml', 'cssselect'].each do |pip|
    python_pip pip do
      action :install
    end
  end

  solr_instance solr_instance_name do
    path "/opt/solr"
    action [:install, :create]
    schema_is_dynamic true
  end

  execute "build_solr_schema" do
    cwd node['askbot']['install']['dir']
    command "python manage.py build_solr_schema -f #{solr_schema}"
    action :run
    user "solr"
    only_if { ::File.exists?("#{solr_schema}/conf")}
  end

  {solr_xml => "solr.xml", solr_config => "solrconfig.xml"}.each do |template,src|
    template template do
  	  source "#{src}.erb"
      owner "solr"
      group "solr"
      mode "0755"
    end
  end

  # hax for bugs in dynamic schema
  link "#{solr_home}/conf/stopwords_en.txt" do
    to "#{solr_home}/conf/stopwords.txt"
    #notifies :restart, "solr_instance[#{solr_instance_name}]", :immediately
  end
end

#Install haystack related packages if haystack == True
if node['haystack']['enabled']
  # Install django-haystack 2.1.0 (default)
    python_pip "django-haystack" do
      #version  "2.1.0"
      action :install
    end
end