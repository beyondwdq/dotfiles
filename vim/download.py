#!/usr/bin/env python
# -*- coding: utf-8 -*-

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
        subfix = url.rsplit('.', 1)[-1]
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


def rm_suffix(s, suffix):
    return s[:-len(suffix)] if s.endswith(suffix) else s


def get_dirname(url):
    dirname = url.split('/')[-1]
    return rm_suffix(dirname, '.git')


def run_scripts(dirname):
    dirpath = os.path.join(os.getcwd(), dirname)
    root_dir = 'scripts'
    script_name = 'post_update.sh'
    script_path = os.path.join(root_dir, dirname, script_name)
    if os.path.exists(script_path):
        print "Running script for %s" % dirname
        subprocess.call([script_path, dirpath])


def parse_line(line):
    items = line.split()
    cmd = url = None
    if (len(items) == 2):
        cmd, url = items
    elif(len(items) == 1):
        url = items[0]
        cmd = get_command_for_url(url)
    else:
        raise ValueError("Invalid line: %s" % line)
    return cmd, url


def show_stats(update, cloned, updated, skipped):
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


def load_lines(filename):
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#'):
                yield line


def bundle_exists(dirname):
    return os.path.exists(dirname)


def run(update=False):
    cloned = []
    updated = []
    skipped = []

    for line in load_lines("repos_urls.txt"):
        cmd, url = parse_line(line)
        dirname = get_dirname(url)

        do_run_script = False
        if bundle_exists(dirname):
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

    show_stats(update, cloned, updated, skipped)


def main():

    update = False
    if len(sys.argv) == 2 and sys.argv[1] == "-u":
        update = True

    run(update=update)

if __name__ == '__main__':
    main()
