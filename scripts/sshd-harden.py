#!/usr/bin/python

import sys, os # for os.system()

def usage():
    print "Usage: python sshd-harden.py <file>"

# set up /etc/ssh/sshd_config
def setup_sshd_config(filename):
    # define configuration: setup contains key, value pairs where keys are
    # strings and values are either ints, strings, or tuples containing strings
    # e.g. if you do setup["X11Forwarding"] = "no", this script will stick
    # "X11Forwarding no" as a line in /etc/ssh/sshd_config. Hopefully this is
    # self-explanatory.
    setup = dict()
    setup["Protocol"]                   = "2"
    setup["PermitRootLogin"]            = "no"
    setup["PasswordAuthentication"]     = "yes"
    setup["PermitEmptyPasswords"]       = "no"
    setup["X11Forwarding"]              = "no"
    setup["MaxAuthTries"]               = "4"
    setup["IgnoreRhosts"]               = "yes"
    setup["PermitUserEnvironment"]      = "no"
    setup["ClientAliveCountMax"]        = "0"
    setup["ClientAliveInterval"]        = "360"
    setup["LoginGraceTime"]             = "60"

    # first try to open the file
    try:
        f = open(filename, "r");
    except IOError:
        print "Configuring sshd_config failed: cannot open file", filename
        return

    # delete lines in the config that we're defining in setup
    lines = list(f)
    for k in setup.keys():
        for line in lines:
            if line[0] != '#' and k in line:
                lines.remove(line)
    f.close()

    # write what's left back into the file
    try:
        f = open(filename, "w");
    except IOError:
        print "Configuring sshd_config failed: cannot open file", filename
        return

    for line in lines:
        f.write(line)
    f.write("# sshd-harden.py\n")

    f.close()

    # append our configuration at the end
    try:
        f = open(filename, "a");
    except IOError:
        print "Configuring sshd_config failed: cannot open file", filename
        return

    # insert all the things in setup into the file
    for k, v in setup.iteritems():
        if type(v) == type(()):
            value = ""
            # separate each thing in the tuple with a comma
            for elem in v:
                value += elem
                value += ","
            value = value[:-1]
            f.write("%s %s\n" % (k, value))
        else:
            f.write("%s %s\n" % (k, v))

    f.close()

if __name__ == "__main__":
    print "Setting up /etc/ssh/sshd_config..."
    if len(sys.argv) == 2:
        setup_sshd_config(sys.argv[1]);
        print "Re-generating host keys..."
        os.system("rm -v /etc/ssh/ssh_host_*_key*")
        os.system("dpkg-reconfigure openssh-server")
        print "Running sshd in test mode to check configuration..."
        os.system("/usr/sbin/sshd -t")
    else:
        usage()

