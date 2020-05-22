#!/bin/bash

# Author : Nicolas De Coster (FabLab ULB)
# Date   : 2019-01
# Version :
#    - 0.0 [2019-01] : Draft/simple local use

# File to automate Xubuntu post-installation on the different machines
# This a very first draft used in FabLab ULB to ease installations of (X)Ubuntu machines.

# Use : as root, launch the script ([sudo] ./x_ubuntu_PostInstall.sh [--all]),
# "--all" option allows you to install all the software without beging asked.
# Wihout the --all option, you will be prompted wether to install
# each software (sometimes by "bench"), with default answer (Y/N).

. ./ask.bash

here=$(pwd)

all=0
if [ "$1" = "--all" ]
then
	all=1
fi

# basic update
apt-get update -y
apt-get upgrade -y

################
# BASIC STUFFS #
################
# git : versionning
# locate : find files easily
# nedit : very simple and lightweight text editor, runs in pure X
# sqlite3 sqlitebrowser : simple database (stores information in small .sqlite files) and its easy GUI
# curl : command line web reader
# kate : rich text editor
# vlc : very popular audio/video player
# inkscape : vector graphics manipulation/creation
# cups : printers management
# python-cups python-serial : two python packages required by inkcut
# gimp : pixel graphics editor
# filezilla : file transfer on various protocols (ftp/sftp)
# gparted : graphical disk partitions editor
# pandoc : powerfull format converter for documents
# texlive : latex packages (required by pandoc to create pdf)
# pdftk : manipulate (cut, concatenate, arrange, ...) pdf files
# gcc-avr binutils-avr avr-libc avrdude make gdb-avr : Atmel AVR tools to program atmel microprocessors
# ffmpeg : popular audio/video transcoder
# fslint : find duplicates and many more operation on large batch of files

basic_stuffs=(git locate nedit sqlite3 sqlitebrowser curl kate vlc inkscape cups cups-client python-cups python-serial gimp filezilla gparted pandoc texlive-latex-base texlive-fonts-recommended pdftk gcc-avr binutils-avr avr-libc avrdude make gdb-avr ffmpeg fslint)
echo ${basic_stuffs[*]}
echo "And several modules..."
if [ $all -eq 1 ] || ask "Install basic stuffs? " Y
then
    add-apt-repository ppa:malteworld/ppa -y # for pdftk
    apt-get update -y
    
    apt-get install ${basic_stuffs[*]} -y
    echo 'Updating the database for locate command.' ; updatedb ;
    #Install inkcut in inkscape
    mkdir -p /usr/share/inkscape/extensions
    cd /usr/share/inkscape/extensions
    wget https://downloads.sourceforge.net/project/inkcut/InkCut-1.0.tar.gz
    tar -xzvf InkCut-1.0.tar.gz
    rm InkCut-1.0.tar.gz
    cd ${here}
fi


#install OpenSCAD
dpkg -s openscad &> /dev/null
if [ $? -eq 1 ]
then
    if [ $all -eq 1 ] || ask "Install OpenSCAD? " Y
    then
        add-apt-repository ppa:openscad/releases -y
        apt-get update -y
        apt-get install openscad -y
    fi
fi

#install FreeCAD
dpkg -s freecad &> /dev/null
if [ $? -eq 1 ]
then
    if [ $all -eq 1 ] || ask "Install FreeCAD (daily)? " Y
    then
        add-apt-repository ppa:freecad-maintainers/freecad-daily -y
        apt-get update -y
        apt-get install freecad-daily -y
    fi
fi

#install Antimony
if [ ! -f /usr/local/bin/antimony ] #check if the file already exists... best way?
then
    if [ $all -eq 1 ] || ask "Install Antimony? " Y
    then
        apt-get install git build-essential libpng-dev python3-dev libboost-all-dev  libgl1-mesa-dev lemon flex qt5-default ninja-build cmake -y
        git clone https://github.com/mkeeter/antimony
        cd antimony
        mkdir build
        cd build
        cmake -GNinja ..
        ninja #NDC comment : this take a bit more time, building all the sources
        ninja install
        cd ${here} #go back to main folder
    fi
fi

#install NodeJS v11
dpkg -s nodejs &> /dev/null
if [ $? -eq 1 ]
then
    if [ $all -eq 1 ] || ask "Install NodeJS v11? " Y
    then
        curl -sL https://deb.nodesource.com/setup_11.x | bash -
        apt-get install nodejs -y
    fi
fi

#install Atom text editor
dpkg -s atom &> /dev/null
if [ $? -eq 1 ]
then
    if [ $all -eq 1 ] || ask "Install Atom text editor? " Y
    then
        apt-get install gvfs-bin -y #atom dependency
        wget -O atom.deb https://atom.io/download/deb
        dpkg -i atom.deb
        rm -f atom.deb
    fi
fi



#install KiCad
dpkg -s kicad &> /dev/null
if [ $? -eq 1 ]
then
    if [ $all -eq 1 ] || ask "Install KiCad? " Y
    then
        add-apt-repository ppa:js-reynaud/kicad-5 -y
        apt update -y
        apt-get install kicad -y
    fi
fi

#install KdEnlive
dpkg -s kdenlive &> /dev/null
if [ $? -eq 1 ]
then
    if [ $all -eq 1 ] || ask "Install KdEnlive? " Y
    then
        apt-get install kdenlive -y
    fi
fi

# basic update (probably unecessary... just to make sure!)
apt-get update -y
apt-get upgrade -y

##########
# REBOOT #
##########
if ask "Reboot now? " N
then
        reboot
fi
