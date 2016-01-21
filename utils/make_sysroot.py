#!/usr/bin/env python

import argparse
import sys
import bz2
import urllib2
import urllib
import urlparse
import posixpath
import cStringIO
import os
import subprocess

parser = argparse.ArgumentParser(prog='make_sysroot')
parser.add_argument('--distro', required=True, help='Distribution')
parser.add_argument('--version', required=True, help='Version')
parser.add_argument('--arch', required=True, help='Architecture')
parser.add_argument('--install', help='Install dir')


args = parser.parse_args(sys.argv[1:])


required_packages = ['libc6', 'libc6-dev', 'linux-libc-dev', 'libicu52', 
                  'libbsd0', 'libbsd-dev', 'libicu-dev', 'libgcc-4.8-dev', 'libstdc++-4.8-dev',
                  'libstdc++6' , 'libstdc++-4.8-dev', 'libatomic1', 'libgcc1']

def get_packages_list(args):
    if args.distro == "ubuntu":
        #Ubuntu.get_package_list(args)
        if not os.path.isfile("Packages.bz2"):
            url = "http://ports.ubuntu.com/ubuntu-ports/dists/%s/main/binary-%s/Packages.bz2" % (args.version, args.arch)
            response = urllib2.urlopen(url)
            print response
        else:
            response = open("Packages.bz2", 'r')
        html = bz2.decompress(response.read())
        print len(html), html[1]
        io = cStringIO.StringIO(html)
        print type(io)

        packages = dict()
        curPackage = None
        i = 0

        for line in io.readlines():
            if len(line) == 1 and line[0] == '\n':
                curPackage = None
                continue

            #print line, len(line), type(line)
            key, value = line.rstrip().split(": ", 1)
            #print key, value
            if curPackage is None:
                #print "'%s'" % (key,)
                assert key == "Package"
                curPackage = dict()
                packages[value] = curPackage
            else:
                curPackage[key] = value


        return packages



all_packages = get_packages_list(args)

for k in all_packages.keys():
    if "gcc" in k:
        print k
        pass

def urlAndNameFromPackage(p):
    url = "http://ports.ubuntu.com/ubuntu-ports/" + p['Filename']
    name = posixpath.basename(urlparse.urlparse(url).path)
    return (url, name)

deps = []

for name in required_packages:
    p = all_packages[name]
    url, filename = urlAndNameFromPackage(p)
    if p.has_key("Depends"):
        for d in p['Depends'].split(', '):
            deps.append(d)
    if not os.path.isfile(filename):
        print "Retrieving:", filename
        urllib.urlretrieve(url, filename)

    #print url, name

    if args.install:
        print "Installing:", filename
        ret = subprocess.call(['dpkg-deb', '-x', filename, args.install])
        assert ret == 0


#Fixup broken symlinks
if args.install:
    for dirname, dirnames, filenames in os.walk(args.install):
        for filename in filenames:
            path = os.path.join(dirname, filename)
            if os.path.islink(path):
                link = os.readlink(path)
                if link[0] == '/': # TODO(tom) fix for windows paths
                    fulllink = os.path.normpath(os.path.join(args.install, "." + link))
                    fixed = os.path.relpath(fulllink, dirname)
                    print fixed
                    os.unlink(path)
                    os.symlink(fixed, path)
