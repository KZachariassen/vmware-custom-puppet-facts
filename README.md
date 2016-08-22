# Add vmware info to puppet facts

##What is this?##
In this project we will use PowerCli to add custom information to our VM's and later on use puppet to gather that information and store it as custom facts.

##How to use this?##
[PowerCli]
Use the PowerCli script to add "tags" to all your vm's. I do this every hour on my vcenter server.
This can take a while to complete if you have a lot of VM'v, so I use one PS script(Start-push_tags_to_vm.ps1) to parallel spawn this task for each host in my vmware setup.

[Puppet]
The custom facter "esc_facts.rb" will pull all defined facts and add then as facts to the VM

##Why do you do that?##
To be able to pull hyper-visor info directly from the agent, and use that info to distribute farms, push DRS policies, debug or whatever is a must have feature for us to have.

##Tested on##
Puppet v4 with both Ubuntu, Debian, Windows 2012 R2 and Windows 2016 as clients.
