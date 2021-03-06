# Cookbook Name:: pecl
# Recipe:: install_packages
#
# Copyright 2011, Chris Fordham
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

if node.pecl.packages.nil?
  log "No pecl packages specified for install, skipping."
  return
end

if node.pecl.packages.kind_of?(Array)
  package_list = node.pecl.packages.join(' ')
else
  package_list = node.pecl.packages
end

execute "install_pecl_packages" do
  command "pecl install --nobuild #{package_list}"
  action :run
end

ruby_block "show_installed_pecl_packages" do
  block do
    Chef::Log.info("#{`pecl list`}")
  end
end