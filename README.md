# Geohash36
Version 0.1.0-25-g5ffc4a3


## WHAT IS THE GEOHASH36 PROJECT ?

Geohash36 [1] ...

[1]

## FEATURES

- Application
  - Ruby VM (2.1 or better)
- Feature Providing Base Libraries
  - RVM
  - Bundler
  - Thor
  - Hypermedia
  - Various Gems (see Gemfile)
- Development
- Development Base Libraries
  - Rake
  - Thor
- Code Quality
  - Code review
  - Yard & related  (gem install yard --no-ri --no-rdoc ; gem install rdiscount --no-ri --no-rdoc)
  - Minimal controllers, delegated to proper Ruby classes
  - Logic free view templates
  - Proper Ruby OOP for base functionality
  - MetricFu/RSpec/Cucumber/DBC/Vagrant/Docker/i18n

## ON WHAT HARDWARE DOES IT RUN?

This Software was originally developed and tested on 32-bit x86 / SMP based PCs running on
Ubuntu and Gentoo GNU/Linux 3.12.x. Other direct Linux and Unix derivates should be viable too as
long as all dynamical linking dependencys are met.


## DOCUMENTATION

A general developers API guide can be extracted from the Yardoc subdirectory which is able to
generate HTML as well as PDF docs. Please refer to the [Rake|Make]file for additional information
how to generate this documentation.


## INSTALLING

If you got this package as a packed tar.gz or tar.bz2 please unpack the contents in an appropriate
folder e.g. ~/mysite/ and follow the supplied INSTALL or README documentation. Please delete or
replace existing versions before unpacking/installing new ones.

Get a copy of current source from SCM

```sh
~# git clone ssh://.... geohash36
```

Get submodules (may not apply)

```sh
~# cd geohash36
~# git submodule init
~# git submodule update
```

Install system dependencies (e.g. Debian/GNU)

```sh
~# apt-get install iconv
~# apt-get install curl screen less vim
~# apt-get install zlib1g zlib1g-dev
```

Install RVM (may not apply)

```sh
~# curl -sSL https://get.rvm.io | bash -s stable
```

Make sure to follow install instructions and also integrate it also into your shell. e.g. for ZSH,
add this line to your .zshrc.

```sh
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" ;

or

~# echo "source /usr/local/rvm/scripts/rvm" >> ~/.zshrc

```

Create proper RVM gemset

```sh
~# rvm --create use 2.1.2@geohash36_project
```

Install Ruby VM 2.1.2 or better

```sh
~# rvm install 2.1.2
```

Install libraries via bundler

```sh
~# gem install bundler
~# bundle
```

## SOFTWARE REQUIREMENTS

This package was developed and compiled under Gentoo GNU/Linux 3.x with the Ruby 2.x.x.
interpreter. It uses several libraries and apps as outlied in the INSTALLING section.

 - e.g. Debian/GNU Linux or Cygwin for MS Win
 - Ruby
 - RVM
 - Bundler


## BUILD PROCESS

Package building such as RPM or DEB has not been integrated at this time.

## SOFTWARE REQUIREMENTS

This package was developed and compiled under Gentoo GNU/Linux 3.x with the Ruby 2.x.x.
interpreter.

## CONFIGURING

Configuration is handled at run-time via $HOME/.geohash36/config.yaml file.

## COMPILING & PACKAGING

```sh
~# rake build
~# rake package
~# rake install
```

## DEVELOPING

### Contributing to code & working on issues

- Clone
- Create issue in GitLab if issue not already created
- Create a new feature branch from develop ( git checkout -b f10_my_new_feature develop)
- Commit regularly ( every 5 mins or so )
- Push once in a while ( once in 30 ~ 45 mins )
- At completion, make merge request assigned to 'Bjoern Rennhak'. **Please do not merge directly to develop.**

#### Rake Tasks

For a full list of Rake tasks suported, use `rake -T`.

Here is a current listing of all tasks:


```
$rake_tasks$
```

#### Thor Tasks

For a full list of Thor tasks suported, use `thor -T`.

Here is a current listing of all tasks:


```
$thor_tasks$
```

## IF SOMETHING GOES WRONG

In case you enconter bugs which seem to be related to the package please check in
the MAINTAINERS file for the associated person in charge and contact him or her directly. If
there is no valid address then try to mail Bjoern Rennhak <bjoern AT clothesnetwork DOT com> to get
some basic assistance in finding the right person in charge of this section of the project.


## COPYRIGHT

Please refer to the COPYRIGHT file in the various folders for explicit copyright notice.  Unless
otherwise stated all remains protected and copyrighted by Bjoern Rennhak (bjoern AT clothesnetwork DOT com).
