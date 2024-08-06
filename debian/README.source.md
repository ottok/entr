## Repository structure

This Debian packaging source is maintained on branch `debian/latest` (naming
following DEP-14) as part of a fork of the upstream repository. This makes it
easier to export and import commits between upstream and downstream Debian.

This structure is compatible with git-buildpackage and is preconfigured with
`debian/gbp.conf` so the git-buildpackage commands don't need extra parameters
most of the time.

To get the Debian packaging sources and have the upstream remote alongside it
simply run:

    gbp clone --verbose git@salsa.debian.org:debian/entr.git
    git remote add upstream https://github.com/eradman/entr.git


## Contributing to the Debian packaging

First clone the Debian packaging repository using git-buildpackage as described
above. Then open https://salsa.debian.org/debian/entr and press "Fork". This is
needed for Salsa to understand that your repository has the same origin. In your
fork, note the git SSH address, e.g. `git@salsa.debian.org:otto/entr.git`, and
add it as new remote (replace 'otto' with your own Salsa username):

    git remote add otto git@salsa.debian.org:otto/entr.git

Do your code changes, commit and push to your repository:

    git checkout -b bugfix/123456-fix-something
    git commit # or `git citool`
    git push --set-upstream otto

If you did edits and need to amend your improvement, run:

    git commit -a --amend # or `git-citool --amend`
    git push -fv

Finally open a Merge Request on salsa.debian.org. If your submission is high
enough quality, the maintainer is likely to approve it and include your
improvement in the revision of the Debian package. The link to open a MR will
automatically display on the command-line after each `git push` run.

There is no need to update the `debian/changelog` file in the commit. It will be
done automatically by the maintainer before next upload to Debian. There is also
no need to submit multiple Merge Requests targeting different branches with the
same change. Just submit the change for the `debian/latest` branch, and the
maintainer will cherry-pick it to other branches as needed.

The Debian packaging repository will only accept changes in the `debian/`
subdirectory. Any fix for upstream code should be contributed directly to
upstream.


## Contributing upstream

This Debian packaging repository and the upstream git repository can happily
co-exist as separate branches in the same git repository. To contribute
upstream, start by opening the upstream project GitHub page, press "Fork" and
add it as yet another git remote to this repository just like in the section
above.

Make git commits, push them to your GitHub fork and open a Pull Request
upstream.


## Importing a new upstream release

To check for new upstream releases run:

    git fetch upstream --tags
    # Note latest tag, e.g. 5.6
    gbp import-orig --uscan --no-interactive --verbose
    gbp dch --verbose --release --distribution=UNRELEASED --new-version=5.6-1 -- debian
    while quilt push; do quilt refresh; done; quilt pop -a
    git commit -am "Update changelog and refresh patches after 5.6 import"

After testing enough locally, push to your fork and open Merge Request on Salsa
for review (replace 'otto' with your own Salsa username):

    gbp push --verbose otto

Note that git-buildpackage will automatically push all three branches
`debian/latest`, `upstream/latest` and `pristine-tar`) and upstream tags to your
fork so it can run the CI. However, merging the MR will only merge one branch
(`debian/latest`) so the Debian maintainer will need to push the other branches
to the Debian packaging git repository manually with `git push`. Is is not a
problem though, as the upstream import is mechanical for the `upstream/latest`
and `pristine-tar` branches. Only the `debian/upstream` branch has changes that
warrant a review and potentially new revisions.


## Uploading a new release

**You need to be a Debian Developer to be able to upload to Debian.**

Before the upload, remember to ensure that the `debian/changelog` is
up-to-date:

    gbp dch -avR
    git commit -am "Update changelog for 5.6-1 release into unstable"

Create a source package with your preferred tool (not documented here).

Do the final checks and sign and upload with:

    debsign *.changes && dput ftp-master *.changes

After upload remember to run:

    gbp tag --verbose
    gbp push --verbose
