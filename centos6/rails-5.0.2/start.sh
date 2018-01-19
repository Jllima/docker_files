#!/bin/bash

__create_user() {
# Create a app to SSH into as.
useradd app
SSH_USERPASS=root
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin app)
echo ssh app password: $SSH_USERPASS

echo "app ALL=(ALL) ALL" >> /etc/sudoers
}

# Call all functions
__create_user
