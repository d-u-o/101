#!/usr/bin/env make -f

What = Duo/101#
Who  = Tim Menzies#
When = 2018,2019#
Email= timm@ieee.org#
Title= DUO 101: An Introduction to Data Mining using/used-by Optimizers#
Where= github.com/d-u-o/101#
Here = my#
Tmp  = $(HOME)/tmp#
Tests= ../tests#

*nix:
	echo 11

############################################################
all: dirs heres luas txts mds chmods

dirs: 
	@if [ ! -d "$(Tmp)"   ];then echo mkdir $(Tmp)  ;mkdir $(Tmp);  fi
	@if [ ! -d "$(Tests)" ];then echo mkdir $(Tests);mkdir $(Tests);fi

chmods:
	@chmod +x $(Here)/*

heres: $(Here)/blank.lua 
luas:  use.lua $(Tests)/use.lua
txts:  ../.gitignore ../requirements.txt 
mds :  ../CITATION.md ../CONTRIBUTING.md ../CODE_OF_CONDUCT.md ../LICENSE.md
	
use.lua               : ; echo "$$USE"      > $@; git add $@
../.gitignore         : ; echo "$$IGNORE"   > $@; git add $@
../LICENSE.md         : ; echo "$$LICENSE"  > $@; git add $@
../CITATION.md        : ; echo "$$CITATION" > $@; git add $@
$(Tests)/use.lua      : ; echo "$$USE"      > $@; git add $@
$(Here)/blank.lua     : ; echo "$$BLANK"    > $@; git add $@
../CONTRIBUTING.md    : ; echo "$$CONTRIB"  > $@; git add $@
../requirements.txt   : ; echo "$$REQUIRES" > $@; git add $@
../CODE_OF_CONDUCT.md : ; echo "$$CONDUCT"  > $@; git add $@

linux: all
	@sudo apt-get update
	@if [ ! `which pip`    ]>&2;then sudo apt-get install python3-pip;fi
	@if [ ! `which lua`    ]>&2;then sudo apt-get install lua;    fi
	@if [ ! `which luajit` ]>&2;then sudo apt-get install luajit; fi
	@if [ ! `which pycco`  ]>&2;then sudo -H pip install pycco;   fi

## todo. needs mac install pip
mac: all
	@if [ ! `which lua`    ] >&2;then brew install lua;          fi
	@if [ ! `which luajit` ] >&2;then brew install luajit;       fi
	@if [ ! `which pycco`  ] >&2;then sudo -H pip install pycco; fi

## what about windows
############################################################
define REQUIRES
lua>=5.2
luajit>=5.2
pycco>=0.6
endef
export REQUIRES

############################################################
define IGNORE
### Vim ###
[._]*.s[a-w][a-z]
[._]s[a-w][a-z]
*.un~
Session.vim
.netrwhist
*~
endef 
export IGNORE

############################################################
define BLANK
-- vim: ft=lua ts=2 sw=2 sts=2 et : cindent : formatoptions+=cro
-- $(What) copyright (c) $(When) $(Who), $(Email)
-- All rights reserved, opensource.org/licenses/BSD-3-Clause
-- For examples of usage, see $(Tests)/xxx.lua.
--------- --------- --------- --------- --------- --------- ---------

local Object=require('use')('src/lib.lua')

--------- --------- --------- --------- --------- --------- ---------
return isMain('lib') and rogues() 
endef 
export BLANK

############################################################
define USE
-- vim: ft=lua ts=2 sw=2 sts=2 et : cindent : formatoptions+=cro
-- $(What) copyright (c) $(When) $(Who), $(Email)
-- All rights reserved, opensource.org/licenses/BSD-3-Clause
--------- --------- --------- --------- --------- --------- ---------

local root = '../'
local seen = {}

function use(f, show)
  if not seen[f] then 
    if show then io.stderr:write('-- ' .. f .. '\n') end
    seen[f] = dofile(root .. f)
  end 
  return seen[f]
end 

return use
endef 
export USE

############################################################
define CITATION

# CITATION

Please cite this as

- $(Who), _$(Title)_, $(When)

Bibtex:

    @misc{$(What),
      author="$(Who)",
      year="$(When)",
      title="$(Title)",
      note="Download from http://$(Where)"
    }
endef
export CITATION

############################################################
define CONDUCT

# Contributor Covenant Code of Conduct

## Our Pledge

In the interest of fostering an open and welcoming environment, we
as contributors and maintainers pledge to making participation in
our project and our community a harassment-free experience for
everyone, regardless of age, body size, disability, ethnicity, sex
characteristics, gender identity and expression, level of experience,
education, socio-economic status, nationality, personal appearance,
race, religion, or sexual identity and orientation.

## Our Standards

Examples of behavior that contributes to creating a positive
environment include:

* Using welcoming and inclusive language
* Being respectful of differing viewpoints and experiences
* Gracefully accepting constructive criticism
* Focusing on what is best for the community
* Showing empathy towards other community members

Examples of unacceptable behavior by participants include:

* The use of sexualized language or imagery and unwelcome 
  sexual attention or advances
* Trolling, insulting/derogatory comments, and personal 
  or political attacks 
* Public or private harassment 
* Publishing others' private information, such as a 
  physical or electronic address, without explicit permission
* Other conduct which could reasonably be considered 
  inappropriate in a professional setting

## Our Responsibilities

Project maintainers are responsible for clarifying the standards
of acceptable behavior and are expected to take appropriate and
fair corrective action in response to any instances of unacceptable
behavior.

Project maintainers have the right and responsibility to remove,
edit, or reject comments, commits, code, wiki edits, issues, and
other contributions that are not aligned to this Code of Conduct,
or to ban temporarily or permanently any contributor for other
behaviors that they deem inappropriate, threatening, offensive, or
harmful.

## Scope

This Code of Conduct applies both within project spaces and in
public spaces when an individual is representing the project or its
community. Examples of representing a project or community include
using an official project e-mail address, posting via an official
social media account, or acting as an appointed representative at
an online or offline event. Representation of a project may be
further defined and clarified by project maintainers.

## Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior
may be reported by contacting the project team at $(Email).
All complaints will be reviewed and investigated and will result
in a response that is deemed necessary and appropriate to the
circumstances. The project team is obligated to maintain confidentiality
with regard to the reporter of an incident.  Further details of
specific enforcement policies may be posted separately.

Project maintainers who do not follow or enforce the Code of Conduct
in good faith may face temporary or permanent repercussions as
determined by other members of the project's leadership.

## Attribution

This Code of Conduct is adapted from the [Contributor Covenant][homepage],
version 1.4, available at
https://www.contributor-covenant.org/version/1/4/code-of-conduct.html

[homepage]: https://www.contributor-covenant.org

For answers to common questions about this code of conduct, see
https://www.contributor-covenant.org/faq

endef
export CONDUCT

############################################################
define LICENSE

# LICENSE

$What  Copyright (c) $When, $Who
All rights reserved, BSD 3-Clause License

Redistribution and use in source and binary forms, with
or without modification, are permitted provided that
the following conditions are met:

- Redistributions of source code must retain the above
  copyright notice, this list of conditions and the 
  following disclaimer.
- Redistributions in binary form must reproduce the
  above copyright notice, this list of conditions and the 
  following disclaimer in the documentation and/or other 
  materials provided with the distribution.
- Neither the name of the copyright holder nor the names 
  of its contributors may be used to endorse or promote 
  products derived from this software without specific 
  prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

endef
export LICENSE


