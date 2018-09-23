This is a WORK IN PROGRESS

# Server for OCP Disconnected Installs
This repository has instructions and scripts to create a server to
support disconnect OCP installations.

## Install RHEL 7.5
Create a VM with 8 GB memory, 4 vCPUs, and a 200 GB storage device.
Mount the file `rhel-server-7.5-x86_64-dvd.iso` as an IDE device.

Start the server, select `Install Red Hat Enterprise Linux 7.5`,
and press the `TAB` key.  Add the option
`inst.ks=https://people.redhat.com/rlucente/ks.cfg` to the line
beginning with `vmlinuz`.  Press the `ENTER` key.

The kickstart file sets the root password to `redhat1!` and installs
the git package.

The server will restart when installation is complete.

NB:  You may need to manually detach the RHEL iso file and restart
the server if the system returns to the installation menu.

## Prepare the Server
To prepare the server to sync with the repositories and images,
login as root and run the commands:

    git clone https://github.com/rlucente-se-jboss/disconnected-ocp-install.git
    cd disconnected-ocp-install

Check the parameters in `install.conf` and adjust accordingly.  At
a minimum, you'll need to set the `RHSM_USER` and `RHSM_PASS`
parameters to match your Red Hat customer service portal login id
and password, respectively.  Then, run the command:

    ./prep-server.sh

## Sync Repos and Images
You can resync the repositories and images whenever you have a
connection to the internet and access to Red Hat's repositories.
To synchronize everything, run the command:

    ./repo-sync.sh

## Configure Repos on each Host
Install VMs for each OCP master, infra, and compute node.  Add the
IP address of each OCP node to the array `OCP_HOST_IPS` in the
`install.conf` file.  Next, run the following command from the host
acting as the repository cache:

    ./config-repos.sh

# Pre-load Docker Images
After installing docker on each OCP node, configuring docker storage,
and starting the docker daemon, run the following command to
pre-populate the docker images before running the OCP ansible
installation scripts.

    ./load-images.sh

