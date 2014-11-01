# Intro

This directory contains the debian packaging files and a handy shell script
to generate a pristine source tarball and add a "debian/" packaging directory
for packages intended for use on [STP's Ubuntu PPA](https://launchpad.net/~simple-theorem-prover/+archive/ubuntu/ppa).

# Steps

1. Make sure your STP git repository is clean
1. Run
   ```
   $ prepare-snapshot.sh <path_to_stp_git_repository_root>
   ```
1. Nagivate to your STP git repository and check that the files in
   ``debian/`` look correct. In particular make sure ``debian/changelog``
   is correct because the script generates a new changelog ( it can also
   append a new entry into the changelog for the new snapshot).
   
   Note snapshots have the date (YYYYMMDD) is their name so if you need to
   upload another package on the same day you should increment the number after
   the date, i.e. ``stp_1.0+1SNAPSHOT20141031-0~trusty1`` becomes
   ``stp_1.0+1SNAPSHOT20141031-1~trusty1``.
1. Build the source package by running the following in the root of the STP repository
   ```
   $ dpkg-buildpackage -S --force-sign
   ```
1. Upload the source package (and related files) to launchpad. The invocation will look 
   something like this.
   ```
   $ dput ppa:simple-theorem-prover/ppa stp_1.0+1SNAPSHOT20141031-0~trusty1_source.changes
   ```
1. Copy the "changelog" and any other changes to the debian files back into the
   debian folder in this repository and commit this so we keep track of the
   changelog and any other important changes to the debian packaging files.

# Useful documents

The debian packaging system is a bit complicated. Thankfully there are many guides to help
you out

* https://help.launchpad.net/Packaging/PPA/BuildingASourcePackage
* http://debian-handbook.info/browse/stable/sect.building-first-package.html
* http://packaging.ubuntu.com/html/
* https://wiki.debian.org/UpstreamGuide
