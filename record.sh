#!/bin/bash
read -p "Check for updates ?(Y/n)" update
if [[ $update == "Y" ]]; then
	sudo pacman -S pipewire pipewire-audio-client-libraries libspa-0.2-bluetooth libspa-0.2-jack
	sudo pacman -S pavucontrol ffmpeg
else
	echo "Loading..."
fi
systemctl --user --now enable pipewire pipewire-pulse
systemctl --user --now start pipewire pipewire-pulse
#sudo reboot
echo "please change the recorded media's output to virtual sink then close pavu"
pavucontrol
pactl load-module module-null-sink sink_name=Virtual_Sink
ffmpeg -f pulse -i Virtual_Sink.monitor ~/Documents/output.wav
read -p "Do you want to unload the module(Y/n)" ans
if [[ $ans == "Y" ]]; then
	MODULE_ID=$(pactl list short modules | grep 'module-null-sink' | awk '{print $1}')
	pactl unload-module $MODULE_ID
fi
