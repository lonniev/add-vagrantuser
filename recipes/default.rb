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

getHomeCmd = Mixlib::ShellOut.new("useradd -D|grep HOME|cut -d '=' -f 2")
getHomeCmd.run_command

homeDir = getHomeCmd.stdout.chomp

userHomePath = "#{homeDir}/vagrant"

user "vagrant" do
    action :create

    comment "Vagrant User"
    manage_home true
    home userHomePath
    shell "/bin/bash"
    password "$1$X7FxekSe$oMDholZuYrBQ3I6NlKIVZ/"
end

ohai "reload_passwd" do
    plugin "etc"
end

directory userHomePath do
    owner "vagrant"
    group "vagrant"
    recursive true
    action :create
end

execute "chown home" do
  command "chown -R vagrant:vagrant #{userHomePath}"
  only_if { Pathname.new( userHomePath ).exist? }
end

group "sudo" do
    action :modify
    members "vagrant"
    append  true
end

group "tsusers" do
    action :create
end

group "tsusers" do
    action :modify
    members "vagrant"
    append  true
end

execute "grant vagrant sudo rights" do
    command "sfile=$(tempfile -m 0440); echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > $sfile; mv $sfile /etc/sudoers.d/vagrant"
    creates "/etc/sudoers.d/vagrant"
end

xSessionFile = "#{userHomePath}/.xsession"

file xSessionFile do
    owner "vagrant"
    group "vagrant"
    mode 0644
    content "xfce4-session"

    action :create_if_missing
end
