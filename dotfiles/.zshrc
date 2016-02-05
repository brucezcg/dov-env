# -*- coding: raw-text -*-

# settings
setopt extendedglob autolist listtypes
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.zsh/history
setopt complete_in_word
setopt multios
setopt hist_ignore_dups
unset hup
stty -ixon

# Shell functions
setenv() { export $1=$2 }  # csh compatibility

# Speed up interactive work - See http://www.webupd8.org/2010/11/alternative-to-200-lines-kernel-patch.html
#if [ "$PS1" ] ; then  
#    mkdir -m 0700 /sys/fs/cgroup/cpu/user/$$
#    echo $$ > /sys/fs/cgroup/cpu/user/$$/tasks
#fi

# terminal specific stuff
if [[ $TERM == "xterm" || $TERM == "xterm-256color" || $TERM == "rxvt" ]]; then
    # Change title when switching directories
    chpwd () { print -Pn "]0;<Z> $USER@$HOST: [%~]" }
    PROMPT="> "
    alias ls="ls -F --color=auto"
elif [[ $EMACS = t ]]; then
    unsetopt zle
    PROMPT="> "
    export PAGER=cat
else 
    PROMPT="> "

    if [[ $TERM == "linux" ]]; then
	loadkeys .dvorak.map
    fi
fi

# stty
stty intr 
stty kill 
stty erase 
stty susp 
stty -istrip


# Make the title change after each command has been completed
[[ $EMACS = t ]] || precmd () { cd . } 

# Filename suffixes to ignore during completion
fignore=(.o .c~ .old .pro)

# Completion control
compctl -g '*(-/)' cd
compctl -g '*.tex *(/)' tex
compctl -g '*.tex *(/)' latex
compctl -g '*.dpf *(/)' dpfview
compctl -g '*.dpf *(/)' dpf2ps
compctl -g '*.dvi *(/)' dvitops
compctl -g '*.dvi *(/)' xdvi
compctl -g '*.lyx *(/)' lyx
compctl -g '*.mp *(/)' mp
compctl -g '*.(<1-9>|man|n)' manm
compctl -C -c -x 'C[0,*/*]' -g '*[^~](*)' + -c

# ls aliases taken from the zsh distribution
alias lsd='ls -ld *(-/DN)'
alias lsa='ls -ld .*'
alias ls='ls -F --color=auto'
alias visit="/usr/local.local/bin/visit"
alias less='less -R'
grel() { grep --color=always $* | less -R }
ackl() { ack --color $* | less -R }
gitgrep() { grep --color=always $* "`git ls-files`" | less -R }
qtpylab() {  /usr/local/bin/ipython qtconsole --pylab=inline & }

# Some single characters. Is this too wild?
alias -g M='|more'
alias -g H='|head'
alias -g T='|tail'


# aliases
alias vi=vim
alias nautilus="nautilus --no-desktop"
alias hostname='uname -n'
# alias mbox="frm -s"
alias xgraph='xgraph \=550x425'
alias gsn="gs -sPAPERSIZE=a4 -DNODISPLAY"
alias gs="gs -sPAPERSIZE=a4"
alias gsx="gs -dNOPLATFONTS -sDEVICE=x11alpha -sPAPERSIZE=a4"
alias gv='ghostview -arguments "-dNOPLATFONTS -sDEVICE=x11alpha" -geometry +100+0 -a4 -magstep -1'
alias gvl="ghostview -geometry +30+100 -a4 -magstep -1 -landscape"
alias pdf2ps="acroread -toPostScript"
alias xterm="xterm -fn lucidasanstypewriter-bold-14 -bg grey20 -fg green -cr green -sb -sl 1000"
alias cds=cd
alias poehebfax="poe -rmarg 50 -nohead -tmarg 50 -stdout -columns 1 -portrait -fontscale 11 -font GamCour -reverse"
alias cpan="perl -MCPAN -e shell"
alias pilot-mail pilot-mail /dev/pilot -f dov@imagic.weizmann.ac.il -k keep -s my-pilot-sm -p /dev/pilot
alias umask-g+w='umask 002'
alias umask-default='umask 022'
alias umask-g-w='umask 022'
alias ps2pdf="ps2pdf -sPAPERSIZE=a4 "
alias wdx="echo -n 'X <= '; pwd; pwd | perl -pe 'chomp' | xclip ; pwd | perl -pe 'chomp' | xclip -selection clip"
alias toxclip="echo $*|xclip"
alias aaaa='setxkbmap us'
alias dvorak='xkbcomp ~/.xkbmap $DISPLAY'
alias sudo='sudo env PATH=$PATH'

# solaris stuff
if [[ `uname -s` == Solaris ]]; then
    alias perldl="PATH=/data/alg/local/bin:/usr/local/bin:$PATH perldl"
    alias tar=gtar
    alias memos='/opt/palm/bin/memos'
    alias vi=vim
    alias sdd-tool=/home/dov/tools/src/sdd-tool/sdd-tool
    alias curl='curl -x http://proxy:8080 -H "Proxy-authorization: Basic ZG92OmdyYXNwYXJ2"'
    alias malsync='malsync -p proxy -r 8080 -u dov -d grasparv'
    alias start_fetchmail="fetchmail"
    alias xmcd="setenv XAPPLRESDIR /data/alg/local/lib/X11/app-defaults/; /data/alg/local/bin/xmcd";
    alias dbx5=/opt/SUNWspro/bin/dbx
fi

palmemo () { install-memo /dev/ttyb -c Misc $* }

# functions
manm () { nroff -man $* | less }
mp () { export TEXFONTS=/data/alg/local/teTeX/texmf/fonts/tfm/public/cm;
        /home/dov/bin/mp $*; unset TEXFONTS }
gspage () { psselect $2 $1 > /tmp/$$.ps; gs /tmp/$$.ps; rm /tmp/$$.ps }
dvipage () { dvips $1; psselect $2 "$1".ps > /tmp/$$.ps; gs /tmp/$$.ps; rm /tmp/$$.ps }
texbook () { xdvi +9 -expert -copy -paper us -s 6 -margins 2.54cm -sidemargin 1.9cm -geometry 650x870 /home/dov/man/texman.dvi }
alias wget="wget --proxy=on"
dvd2iso () { 
    image="/isos/movies/dvd.iso";
    echo -n "Creating $image...";
    dd if=/dev/dvd of=$image;
    echo "Done..."
}

# various other settings
# Exclude the slash and equal signs

ttyctl -f

fixtty () { 
    stty ospeed 9600 parenb cstopb -clocal loblk -istrip -ixoff 
}


WORDCHARS='*?_-.[]~&;\!#$%^(){}<>'
slash_in_word=0

set-slash-in-word () {
    WORDCHARS='*?_-.[]~&;\!\#\$%^(){}<>/'
}

set-noslash-in-word () {
    WORDCHARS='*?_-.[]~&;\!\#\$%^(){}<>'
}

# These functions are mainly used interactively
copy-last-to-whitespace () {
    set-slash-in-word
    zle copy-prev-word
    set-noslash-in-word
}

back-to-whitespace () {
    set-slash-in-word 
    zle backward-word
    set-noslash-in-word
}

forward-to-whitespace () {
    set-slash-in-word 
    zle forward-word
    set-noslash-in-word
}

backward-kill-to-whitespace () {
    set-slash-in-word 
    zle backward-kill-word
    set-noslash-in-word
}

toggle-slash-in-word () {
    slash_in_word=$[1-$slash_in_word]
    if (($slash_in_word)) {
        WORDCHARS='*?_-.[]~&;\!\#\$%^(){}<>/'
    } else {
        WORDCHARS='*?_-.[]~&;\!\#\$\%^(){}<>'
    }
}

# picture rotation routines
rot270() { jpegtran -rotate 270 $1 > $1.tmp; mv $1.tmp $1 }
rot90() { jpegtran -rotate 90 $1 > $1.tmp; mv $1.tmp $1 }

# transfer routines
toxfer() { scp $* imagic.weizmann.ac.il:~dov/public_html/xfer }

# Create widgets from functions that we want to bind
zle -N copy-last-to-whitespace
zle -N back-to-whitespace
zle -N forward-to-whitespace
zle -N backward-kill-to-whitespace

# bindkeys
bindkey -e
bindkey "^[[a" forward-word    
bindkey "^[[b" backward-word   
bindkey "^[[c" backward-kill-word
bindkey "^[[f" undo
bindkey "n" history-beginning-search-forward
bindkey "p" history-beginning-search-backward
bindkey "î" history-beginning-search-forward
bindkey "ð" history-beginning-search-backward
bindkey "ñ" push-line
bindkey "â" backward-word
bindkey "æ" forward-word
bindkey "ø" execute-named-cmd
bindkey "\t" expand-or-complete-prefix
bindkey '[i' back-to-whitespace
bindkey '[k' back-to-whitespace
bindkey '[h' forward-to-whitespace
bindkey '[j' forward-to-whitespace
bindkey "ÿ" backward-kill-to-whitespace
bindkey 'c' copy-last-to-whitespace
bindkey "^È" backward-kill-to-whitespace
bindkey 'ã' copy-last-to-whitespace
bindkey 'Â' back-to-whitespace
bindkey 'Æ' forward-to-whitespace
bindkey '[3D' back-to-whitespace
bindkey '[3C' forward-to-whitespace

# path
path=(/usr/local/forte4j/teamware/bin
      /usr/local/bin 
      /usr/java/jre1.6.0_01/bin
      /usr/X11R6/bin 
      $HOME/scripts
      $HOME/Scripts 
      $HOME/scripts 
      $HOME/bin
      /usr/bin
      /bin
      /usr/sbin
      /sbin
      /usr/local/matlab/bin/
      )

# environment variables
if [[ `uname -s` == Linux ]] {
    #setenv PERLVER `perl -MConfig -e 'print $Config{api_versionstring}'`
    setenv PERLVER "5.12.0"
    setenv PERLOS `perl -MConfig -e 'print $Config{archname}'`
    setenv PERL5LIB /usr/local/lib/perl5/${PERLVER}:/usr/local/lib/perl5/${PERLVER}/${PERLOS}:/usr/local/lib/perl5/site_perl/${PERLVER}:/usr/local/lib/perl5/site_perl/${PERLVER}/${PERLOS}:/usr/lib/perl5/vendor_perl/${PERLVER}:/usr/lib/vendor_perl/${PERLVER}/${PERLOS}:/usr/lib/vendor_perl/perl5/site_perl/${PERLVER}:/usr/lib/vendor_perl/perl5/site_perl/${PERLVER}/${PERLOS}:/nmr/dov/Projects/Lib/perl:/nmr/dov/Projects/Lib/perl/$OS/$PERLVER
    
    setenv QTDIR /usr/lib/qt4
}
setenv XMCD_LIBDIR /usr/X11R6/lib/X11/xmcd
setenv OS linux_i386
setenv NHVL_PATH /home/dov/nhvl2/gip_db/
setenv MASEHOME /project/mase
setenv PILOTPORT /etc/udev/devices/ttyUSB1
setenv GS_LIB /usr/share/ghostscript/fonts
setenv PGPLOT_DIR /usr/local/pgplot
setenv PGPLOT_DEV      /xwindow
gtk-head-env() {
    export PKG_CONFIG_PATH=/opt/gtk-head/lib/pkgconfig:$PKG_CONFIG_PATH 
    export LD_LIBRARY_PATH=/opt/gtk-head/lib
    export PATH=/opt/gtk-head/bin:$PATH
    export GTK2_RC_FILES=/home/dov/.gtkrc-2.0.head
}

# Set up a public development enviroment. Works e.g. for gimp and gegl.
pub-dev-env() {
    export PKG_CONFIG_PATH=/usr/local/public-dev/lib/pkgconfig 
    export LD_LIBRARY_PATH=/usr/local/public-dev/lib:$LD_LIBRARY_PATH 
    export PATH=/usr/local/public-dev/bin:$PATH 
    export CPPFLAGS="-I/usr/local/public-dev/include"
    export LDFLAGS="-L/usr/local/public-dev/lib"
    export ACLOCAL_FLAGS="-I /usr/local/public-dev/share/aclocal -I /usr/share/aclocal"
    export PYTHONPATH=/usr/local/public-dev/lib/python2.7/site-packages:$PYTHONPATH
    export GI_TYPELIB_PATH=/usr/local/public-dev/lib/girepository-1.0
}
gtk210-env() {
    export PKG_CONFIG_PATH=/opt/gtk-2.10/lib/pkgconfig:$PKG_CONFIG_PATH 
    export LD_LIBRARY_PATH=/opt/gtk-2.10/lib
    export PATH=/opt/gtk-2.10/bin:$PATH
}
mingw32env() {
    TARGET=mingw32
    export PREFIX="/usr/local/mingw32"
    export CC="i686-w64-mingw32-gcc -mms-bitfields"
    export CXX="i686-w64-mingw32-g++ -mms-bitfields"
    export AR=i686-w64-mingw32-ar
    export RANLIB=i686-w64-mingw32-ranlib
    export CFLAGS="-O2 -march=i586 -mms-bitfields"
    export CXXFLAGS="-O2 -march=i586 -mms-bitfields"
    export PKG_CONFIG_PATH=$PREFIX/$TARGET/lib/pkgconfig
    export PATH=$PREFIX/bin:$PREFIX/$TARGET/bin:/bin:/usr/bin
    export LD_LIBRARY_PATH=$PREFIX/$TARGET/lib
    export LDFLAGS=-L$PREFIX/$TARGET/lib
    export OBJDUMP=$PREFIX/bin/mingw32-objdump
    export HOST_CC=/usr/bin/gcc
    export OBJSUFFIX=".obj"
    export PROGSUFFIX=".exe"
}

# Display an image from a webcam on the N900
vcam() {
  sudo n900-up.sh
  zap -9 -ni -9 gst-launch
  ssh groma "env DISPLAY=:0 ssh -X dov@usb gst-launch v4l2src device=/dev/video0 ! 'video/x-raw-yuv,width=320,height=240,framerate=25/1' ! videobalance brightness=0.25 ! aspectratiocrop aspect-ratio=16/9 ! videoflip method=horizontal-flip ! xvimagesink"
}


# Weizmann specific stuff
if [[ $HOST == "echo" || $HOST == "mega" ]]; then
# environment variables for zsh
  export http_proxy=http://wwwproxy.weizmann.ac.il:8080
  export PRINTER=br1a
fi

# Hadassa Group development

export GDK_USE_XFT=1
export TEXINPUTS=.:/usr/local/share/texmf/tex//:/usr/share/texmf/tex//::/usr/share/texmf/texlive//
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
export CVS_RSH=ssh
export ALGLIBS=/home/dov/orbotech/alglibs
export SVN_EDITOR=vim
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:/usr/local/lib64/python2.7/site-packages:
#export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"
alias mntsec='sudo /sbin/modprobe cryptoloop; sudo /sbin/modprobe blowfish; sudo losetup -e blowfish /dev/loop0 /space1/secure; sudo mount -t ext2 /dev/loop0 /mnt/loop'
alias umntsec='sudo umount /dev/loop0; sudo losetup -d /dev/loop0; sudo sync'
setenv PERLVER `perl -MConfig -e 'print $Config{version}'`
setenv PERLOS `perl -MConfig -e 'print $Config{archname}'`
setenv PERL5LIB /usr/local/lib/perl5/${PERLVER}:/usr/local/lib/perl5/${PERLVER}/${PERLOS}:/usr/local/lib/perl5/site_perl/${PERLVER}:/usr/local/lib/perl5/site_perl/${PERLVER}/${PERLOS}:/usr/local.local/lib/perl5/${PERLVER}:/usr/local.local/lib/perl5/${PERLVER}/${PERLOS}:/usr/local.local/lib/perl5/site_perl/${PERLVER}:/usr/local.local/lib/perl5/site_perl/${PERLVER}/${PERLOS}:/usr/lib/perl5/vendor_perl/${PERLVER}:/usr/lib/vendor_perl/${PERLVER}/${PERLOS}:/usr/lib/vendor_perl/perl5/site_perl/${PERLVER}:/usr/lib/vendor_perl/perl5/site_perl/${PERLVER}/${PERLOS}:/nmr/dov/Projects/Lib/perl:/nmr/dov/Projects/Lib/perl/$OS/$PERLVER
export LESSCHARSET=utf-8

# Configure with debugging
alias configuredebug='env CPPFLAGS=-DDEBUG CFLAGS="-g -O0" CXXFLAGS="-g -O0" ./configure'

# Make perl stop complaining
unset LANG
setenv LC_ALL_C


#. /home/dov/lib/zsh/mouse.zsh
#zle-toggle-mouse
#<Esc>m to toggle the mouse in emacs mode
#bindkey -M emacs '\em' zle-toggle-mouse
alias aaaa="setxkbmap en_US"
alias dvorak="xkbcomp ~/.xkbmap $DISPLAY"

alias samiam=/usr/local/samiam/runsamiam 
export ANDROID_EMULATOR_FORCE_32BIT=1
export PATH=/space/android-sdk-linux_x86/platform-tools:$PATH

function -K adblist { reply=(`adb shell ls -Fd $1\*|adblsf`) } 
compctl -K adblist adb

# Go support
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

