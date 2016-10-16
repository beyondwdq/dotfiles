#!/usr/bin/env python
# -*- coding: utf-8 -*-

#----------------------------------------------------------------------
# File name: download.py
# Author: Wang Danqi
# Creation Date: Fri Mar 23 13:14:53 2012
#----------------------------------------------------------------------

import os
import sys
import subprocess


cmdstr_mapping = {
        "git": (["git", "clone"], ["git", "pull"]),
        "hg": (["hg", "clone"], ["hg", "pull"])
        }


def get_command_string(cmd, update):
    return cmdstr_mapping[cmd][1 if update else 0]


def get_command_for_url(url):
    cmdprot_mapping = {
            "git": "git",
            "hg": "hg"
            }

    cmd = "git"
    protocol = url.split(':')[0]
    if protocol in cmdprot_mapping:
        cmd = cmdprot_mapping[protocol]
    else:
        subfixes = url.split('.')
        if len(subfixes) > 1:
            subfix = subfixes[-1]
            if subfix in cmdprot_mapping:
                cmd = cmdprot_mapping[subfix]

    return cmd


def clone_repos(cmd, url):
    full_cmd = get_command_string(cmd, update=False) + [url]
    print "running command: " + " ".join(full_cmd)
    subprocess.call(full_cmd)


def update_repos(cmd, dirname):
    full_cmd = get_command_string(cmd, update=True)
    print "running command: " + " ".join(full_cmd)
    subprocess.call(full_cmd, cwd=dirname)


def get_dirname(url):
    return ".".join(url.split('/')[-1].split('.')[0:-1])


def run_scripts(dirname):
    dirpath = os.path.join(os.getcwd(), dirname)
    root_dir = 'scripts'
    script_name = 'post_update.sh'
    script_path = os.path.join(root_dir, dirname, script_name)
    if os.path.exists(script_path):
        print "Running script for %s" % dirname
        subprocess.call([script_path, dirpath])


def line_to_dict(line, sep1=None, sep2=':'):
    mapping = {}
    items = line.split(sep1)
    for item in items:
        k, v = item.split(sep2)
        mapping[k] = v
    return mapping


def main():

    update = False
    if len(sys.argv) == 2 and sys.argv[1] == "-u":
        update = True

    cloned = []
    updated = []
    skipped = []
    for line in open("repos_urls.txt"):
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        items = line.split()
        cmd = None
        url = None
        if (len(items) == 2):
            cmd, url = items
        elif(len(items) == 1):
            url = items[0]
            cmd = get_command_for_url(url)
        else:
            print >>sys.stderr, "Invalid line: %s" % line
            sys.exit(1)

        dirname = get_dirname(url)
        do_run_script = False
        if os.path.exists(dirname):
            if update:
                print "Updating %s in dir:%s" % (url, dirname)
                update_repos(cmd, dirname)
                updated.append(url)
                do_run_script = True
            else:
                print "Skipping %s" % url
                skipped.append(url)
        else:
            print "Cloning %s" % url
            clone_repos(cmd, url)
            cloned.append(url)
            do_run_script = True

        if do_run_script:
            run_scripts(dirname)

        print ""

    print "Number cloned:%s" % len(cloned)
    if (len(cloned)):
        print "\t\n".join(cloned)

    if update:
        print "Number updated:%s" % len(updated)
        if (len(updated)):
            print "\t\n".join(updated)
    else:
        print "Number skipped:%s" % len(skipped)
        if (len(skipped)):
            print "\t\n".join(skipped)

if __name__ == '__main__':
    main()
