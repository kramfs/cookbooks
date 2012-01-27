# Cookbook Name:: boto
# Recipe:: install
#
# Copyright 2012, Chris Fordham
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

remote_file "#{Chef::Config[:file_cache_path]}/#{node['boto']['pkg_filename']}" do
  source node['boto']['pkg_url']
  checksum node['boto']['src_checksum']
  mode "0644"
end

cookbook_file "#{Chef::Config[:file_cache_path]}/boto-installed.py" do
  content "boto-installed.py"
  owner "root"
  mode "00755"
end

bash "install_boto_#{node[:boto][:src_version]}" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  ./boto-installed.py || ( tar -zxf #{node['boto']['pkg_filename']} && cd boto-#{node['boto']['src_version']} && python setup.py install )
  EOH
end