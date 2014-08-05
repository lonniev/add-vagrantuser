#
# Cookbook Name:: add-vagrantuser
# Recipe:: default
#
# Copyright 2014, Lonnie VanZandt
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

user "vagrant" do
    action :create
    comment "Vagrant User"
    home "/home/vagrant"
    password "$1$X7FxekSe$oMDholZuYrBQ3I6NlKIVZ/"
end

user "vagrant" do
    action :modify
    gid "sudo"
end

execute "grant vagrant sudo rights" do
    command "sfile=$(tempfile -m 0440); echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > $sfile; mv $sfile /etc/sudoers.d/vagrant"
    creates "/etc/sudoers.d/vagrant"
end