#
# Cookbook Name:: nova
# Recipe:: source
#
# Copyright 2010, Opscode, Inc.
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
#

execute "easy_install virtualenv"

package "bzr"

execute "bzr init-repo nova" do
  cwd node[:nova][:services_base_dir]
  not_if { File.directory?(node[:nova][:nova_base_dir]) }
end

execute "bzr branch #{node[:nova][:bzr_branch]} #{local_branch_name}" do
  cwd node[:nova][:nova_base_dir]
  not_if { File.directory?(node[:nova][:local_branch_dir]) }
end

execute "python tools/install_venv.py" do
  cwd node[:nova][:local_branch_dir]
  not_if { File.exists?(File.join(node[:nova][:local_branch_dir], ".nova-venv/bin/activate")) }
end

file File.join(local_branch_dir, "/.nova-venv/lib/python2.6/site-packages/nova.pth") do
  content local_branch_dir
end

bash do
  code "./tools/with_venv.sh ./bin/nova-manage user admin admin"
  cwd node[:nova][:local_branch_dir]
  not_if "./tools/with_venv.sh ./bin/nova-manage user list | grep admin"
end

bash do
  code "./tools/with_venv.sh ./bin/nova-manage project admin admin admin"
  cwd node[:nova][:local_branch_dir]
  not_if "./tools/with_venv.sh ./bin/nova-manage project list | grep admin"
end

bash do
  code "./tools/with_venv.sh ./bin/nova-manage project create admin admin admin"
  cwd node[:nova][:local_branch_dir]
  not_if "./tools/with_venv.sh ./bin/nova-manage project list | grep admin"
end

bash do
  code "./tools/with_venv.sh ./bin/nova-manage project zip admin admin"
  cwd node[:nova][:local_branch_dir]
  not_if "./tools/with_venv.sh ./bin/nova-manage project list | grep admin"
end

execute "unzip nova.zip" do
  cwd node[:nova][:local_branch_dir]
end
