# Cookbook Name:: resolver
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

g = gem_package "dnsruby" do
  action :nothing
end
 
g.run_action(:install)
Gem.clear_paths

require 'dnsruby'

if ( node['resolver']['nameservers'].nil? or node['resolver']['nameservers'] == "" )
  log "No nameservers specified, using existing nameservers in resolv.conf"
  nameservers = Dnsruby::Config::new::nameserver()
else
  nameservers = node['resolver']['nameservers']
end
log "Using nameservers => #{nameservers}"

search = false
if node['resolver']['search']
  search = node['resolver']['search']
else
  search = Dnsruby::Config::new::search().map {|element| "#{element}" }.join(' ')
end

if ( search and search.length > 0 )
  log "Setting search => #{search}" 
end

template "/etc/resolv.conf" do
  source "resolv.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :nameservers => nameservers,
    :search => search
  )
end

resolvers = nameservers.map {|element|
  "#{element}"
}.join(',')

script "set_resolvers_tag_#{resolvers.gsub(',', '-')}" do
  interpreter "bash"
  user "root"
  code <<-EOH
( if type -P rs_tag &>/dev/null; then rs_tag --add 'node:resolvers=#{resolvers}'; fi ) || true
  EOH
end