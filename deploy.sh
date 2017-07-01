#!/bin/bash
VER=$(date "+%Y.%m.%d-%H.%M.%S").ver

safe_copy () {
	local src_dir=$1
	local file=$2
	local dest_dir=$3

	mkdir -p $dest_dir
	if [ -f $dest_dir/$file ]
	then
		mv $dest_dir/$file $dest_dir/$file.$VER
		echo Backup $dest_dir/$file as $dest_dir/$file.$VER
	fi
	cp $src_dir/$file $dest_dir/$file
	echo Copy $file to $dest_dir/$file
}

configure_git () {
  		git config --global user.email "awheeler294@gmail.com"
  		git config --global user.name "awheeler294"
}

enviroment_options='KDE i3 Cancel'

PS3='Select Environment: '
select environment in $enviroment_options
do
	if [ $environment == 'KDE' ]
	then

    configure_git

		distro_packages='i3-default-artwork i3-gaps i3-help
i3-scripts i3exit i3lock i3status-manjaro artwork-i3 conky-i3
perl-anyevent-i3 dmenu-manjaro rofi xfce4-terminal pamac nitrogen firefox'
		for package in $distro_packages
		do
			if [ ! $(sudo pacman -Qi $package > /dev/null) ]
			then
				to_install=${to_install:+$to_install }$package
			fi
		done
		sudo pacman -S --noconfirm $to_install

		AUR_packages='unclutter-xfixes-git micro google-chrome vivaldi'
		for package in $AUR_packages
		do
			if [ ! $(sudo pacman -Qi $package > /dev/null) ]
			then
				to_install=${to_install:+$to_install }$package
			fi
		done
		yaourt -Syua --noconfirm $to_install

#		safe_copy i3_kde set_window_manager.sh ~/.config/plasma-workspace/env

#		safe_copy xfce4_terminal terminalrc ~/.config/xfce4/terminal

#		safe_copy bash .bashrc ~

#		for file in $( ls i3_kde/i3_files )
#		do
#			safe_copy i3_kde/i3_files $file ~/.i3
#		done

#		for file in $( ls xfce4_terminal/color_schemes )
#		do
#			safe_copy xfce4_terminal/color_schemes $file ~/.local/share/xfce4/terminal/colorschemes
#		done

		break

	elif [ $environment == 'i3' ]
	then

	  configure_git

		packages='atom dropbox firefox flatpak gnome-calculator google-chrome micro mincraft-launcher python-pip qdirstat sublime-text tlp tty-clock unclutter-xfixes-git vivaldi vivaldi-ffmpeg-codecs xfce4-power-manager xfce4-power-manager xfce4-session xfce4-settings xfce4-notifyd xfce4-terminal zsh'

		yaourt -Syua --noconfirm $packages


    i3_bars='i3Status polybar xfce4panel Cancel'

    PS3='Bar type: '
    select bar in $i3_bars
    do
    	if [ $bar == 'i3status' ]
    	then
    	  xfce4_panel_packages='i3status-manjaro ttf-font-awesome'

   	    yaourt -Syua --noconfirm $xfce4_panel_packages

  	    ./dotdrop.sh install --profile=i3status

  	    sudo pip install BeautifulSoup4
	      sudo pip install requests
	      mkdir ~/bin
	      cd ~/bin
	      git clone https://github.com/calzoneman/i3-weather.git
	      cd -

    	break

    	elif [ $bar == 'i3polybar' ]
   	  then
    	  xfce4_panel_packages='polybar ttf-font-awesome'

   	    yaourt -Syua --noconfirm $xfce4_panel_packages

  	    ./dotdrop.sh install --profile=i3status
   	  break

   	  elif [ $bar == 'xfce4panel' ]
  	  then
  	    xfce4_panel_packages='orage xfce4-battery-plugin xfce4-cpufreq-plugin xfce4-cpugraph-plugin xfce4-cpugraph-plugin xfce4-fsguard-plugin xfce4-hardware-monitor-pluginxfce4-netload-plugin xfce4-panel xfce4-weather-plugin xfce4-weather-plugin-menda-circle-icons xfce4-whiskermenu-plugin'

  	    yaourt -Syua --noconfirm $xfce4_panel_packages

  	    ./dotdrop.sh install --profile=xfce-panel
  	  break

    	else
    			echo Exit

    			break

    	fi

    done

		break

	else
		echo Exit

		break

	fi
done
