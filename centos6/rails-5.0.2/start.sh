#!/bin/bash

__create_user() {
# Create a app to SSH into as.
useradd www-data
SSH_USERPASS=root
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin www-data)
echo ssh www-data password: $SSH_USERPASS

echo "www-data ALL=(ALL) ALL" >> /etc/sudoers
}

# Call all functions
__create_user
