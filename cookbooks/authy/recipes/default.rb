#
# authy/recipes/default.rb
#
# Sets up authy-ssh (https://github.com/authy/authy-ssh) for the "deploy" user.
# Then forces that user to go through authy's 2fa before being granted ssh
# access. You'll need an API key from authy to get this running.
# https://www.authy.com/integrations/ssh
# https://github.com/authy/authy-ssh
#

api_key = 'PUT YOUR API KEY HERE'
banner = 'Authentication via authy-ssh successful.'

# tl;dr: go to cloud.engineyard.com, edit the environment this is on, and
# REMOVE any ssh keys that you have added below. Make sure you click "apply"
# after doing that, but BEFORE running this recipe. Yeah, it's tricky.
#
# More detailed explanation:
#
# EY Cloud Classic only allows one user for direct customer access: "deploy".
# Unfortunately, this means that an organization of N people must all use
# the same ssh user ("deploy"), and to add to our pain here, authy-ssh will use
# the authy ID corresponding to the first entry it finds for a given user in
# its config file. So if I write out deploy:AUTHYID and deploy:ANOTHERID in
# the config file, it'll just read the first one, meaning only one employee
# in your organization will have the right authenticator set up on their phone
# or whatever device.
#
# Translation: you have to map SSH public keys and specific IDs obtained
# through Authy's dashhboard (https://dashboard.authy.com/) here. This is the
# only known way to get authy to play well with EY Cloud, so painful or not,
# this is where you're at.
#
# NOTE: This has _nothing_ to do with your existing SSH keys in EY Cloud. If
# you set up your ssh keys with the dashboard, you should probably remove them
# from the environment and only have them listed here. It's possible that SSH
# would allow a user with the same key in both places in through bypassing
# authy-ssh because it found its public key in authorized_keys *before* finding
# the forced-command version of that same public key.
#
# In other words, a valid authorized_keys file for authy-ssh looks like this:
#
# command="/usr/local/bin/authy-ssh login AUTHYIDHERE" <key text here>
#
# There should be one entry per line per user. Anything that comes before that
# MIGHT be taken as a valid key by sshd depending on how sshd's logic for
# finding valid ssh public keys is implemented, which may be different for
# any given version comparison (e.g. upgrades might change that logic).
#
# You get these user numbers - the authy ids - from authy:
# https://dashboard.authy.com/
#
users = [
  {
    # someuser@your.tld -- useful to track which is which with a comment
    :pubkey => 'PUBLIC KEY HERE',
    :authy_id => 123
  },
  {
    # anotheruser@your.tld
    :pubkey => 'ANOTHER PUBLIC KEY HERE',
    :authy_id => 789
  }
]

# Create the configuration for authy-ssh itself
template "/usr/local/bin/authy-ssh.conf" do
  owner 'root'
  group 'root'
  mode 0655
  source "authy-ssh.conf.erb"
  variables({
    :api_key => api_key,
    :banner  => banner
  })
end

# Create the authy-ssh script that'll do the heavy lifting
template "/usr/local/bin/authy-ssh" do
  owner 'root'
  group 'root'
  mode 0755
  source "authy-ssh.erb"
  variables({})
end

# Finally, write out the mapping of user public keys and authy ids to the
# deploy user's authorized_keys file.
users.each do |u|
  execute "add_to_authorized_keys" do
    command %Q{echo "command=\\"/usr/local/bin/authy-ssh login #{u[:authy_id]}\\" #{u[:pubkey]}" >> /home/deploy/.ssh/authorized_keys}
    not_if "grep -i 'authy-ssh login #{u[:authy_id]}' /home/deploy/.ssh/authorized_keys"
  end
end
