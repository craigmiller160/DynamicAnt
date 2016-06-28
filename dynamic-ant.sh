#!/bin/bash
# Shell script to trigger the dynamic ant operation

function main {

	if [ ! -f "$HOME/.dant/dant.properties" ]; then
		prompt_configuration
	fi

	source "$HOME/.dant/dant.properties"
	if [ "$binPath" == "" ]; then
		prompt_configuration
	fi

	if [ ! -d "$binPath" ]; then
		prompt_configuration
	fi

	if [ $# -ne 1 ]; then
		echo "Error! The source xml file must be provided for this script to run"
		exit 1
	fi

	ant -buildfile /Users/craigmiller/Documents/DynamicAnt/bin/build.xml -Dinput "$(pwd)/$1" -Dhome $HOME

}

function prompt_configuration {

	echo "Dynamic Ant is not configured, or the configuration values are invalid. It cannot run until configuration is set."
	read -p "Configure now? (y/n): "
	case $REPLY in
		y|Y) configure=true ;;
		n|N) configure=false ;;
		*)
			echo "Error! Invalid input, please try again."
			exit 1
		;;
	esac

	if $configure ; then
		run_configuration
	else
		echo "Goodbye"
		exit 0
	fi

}

function run_configuration {

	echo "What is the full path to the 'bin' directory in the Dynamic Ant package?"
	read -p "Package: "
	binPath="$REPLY"
	if [ ! -d "$binPath" ]; then
		echo "Error! Invalid path. $binPath"
		exit 1
	fi

	if [ ! -d "$HOME/.dant" ]; then
		mkdir "$HOME/.dant"
		if [ $? -ne 0 ]; then
			echo "Unable to create .dant directory for storing configuration values. Please check script permissions and ownership and try again."
			exit 1
		fi
	fi

	

	echo "# Dynamic Ant properties" > "$HOME/.dant/dant.properties"
	echo "binPath=\"$binPath\"" >> "$HOME/.dant/dant.properties"

	echo "Configuration complete, you're now ready to run Dynamic Ant."
	exit 0

}

main "${@}"
