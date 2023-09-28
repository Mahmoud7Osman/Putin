if [ ! -d ./bin ]; then
	printf "Error: Please Change Directory To Putin First Then Source Me.\n"
	exit 1
fi


source cofiles/console_colors
source cofiles/exports
source cofiles/aliases
source cofiles/functions

clear

printf "${green}PUTIN$creset ${red}v1.0$creset\n"
printf "Checking For ${green}Updates$creset ...\n"
printf "Starting The ${green}Putin$creset Interactive ${cyan}Console$creset ...\n\n"

putin(){
	if [ "$1" == "help" ]; then
		bash $PUTIN/cofiles/help.sh
		return
	fi
	if [ "$1" == "list" ];then
		if [ "$2" == "projects" ];then
			ls $PUTIN/factory/ --color
			return
		fi
		return
	fi
	if [ "$1" == "open" ];then
		if [ ! -d "$PUTIN/projects/$2" ];then
			error "Project Not Found"
			return
		fi
		say "Opening Selected Project ..."
		AP="$2"
		PROJECT="$PUTIN/projects/$2"
		cd $PROJECT	
		return
	fi
	if [ "$1" == "close" ];then
		AP="-"
		PROJECT="-"
		cd $PUTIN
		return
	fi
	if [ "$1" == "create" ];then
		if [ "$2" == '' ];then
			usage "putin create <ProjectName>"
			return 1
		fi


		say "Creating A New Project            ..."
		mkdir $PUTIN/projects/"$2" &> /dev/null
		say "Creating Project's Factory Space  ..."
		mkdir $PUTIN/factory/"$2"  &> /dev/null
		say "Creating Project's Payload Space  ..."
		mkdir $PUTIN/projects/"$2"/payloads &> /dev/null
		say "Creating Project's Resources      ..."
		mkdir $PUTIN/projects/"$2"/resources &> /dev/null
		say "Creating Project's Binaries Space ..."
		mkdir $PUTIN/projects/"$2"/binaries  &> /dev/null
		mkdir $PUTIN/projects/"$2"/functions &> /dev/null
		touch $PUTIN/projects/"$2"/main.c    &> /dev/null

		if [ $? != 0 ];then
			error "Invalid Project Name"
			return 2
		fi

		say "Project '$2' Created Successfully"		
		return
	fi
	if [ "$1" == "remove" ];then
		caution "This Operation Cannot Be Undone !"
		caution "Please Click On Enter Twice To Confirm Removing The Specified Project"
		read;read
		say "Deleting The Project..."
		rm -rif "$PUTIN/projects/$2" &> /dev/null
		say "Deleting The Factory Space..."
		rm -rif "$PUTIN/factory/$2" &> /dev/null
		return
	fi
	if [ "$1" == "setup" ];then
		say "Starting The Setup (ROOT Privileges Needed)"
		
		which micro &> /dev/null || { say "Installing Micro Editor ..."; sudo apt install micro; }
		which gcc &> /dev/null   || { say "Installing Compilers    ..."; sudo apt install clang; }
		
		say "Setup Finished, Restarting in 3 Seconds ..."
		sleep 3
		deactivate; cd $PUTIN; source activate.sh 
		return
	fi

	if [ "$1" == "lab" ];then
		if [ "$2" == "status" ];then
			if [ -f "$PUTIN/lab/lock" ];then
				say "Laboratory is Busy And Locked"
				return
			fi
			say "Laboratory is Open For Use"
			return
		fi

		if [ "$2" == "unlock" ];then
		    say "Manually Unlocking The Laboratory..."
		    rm $PUTIN/lab/* &> /dev/null
		    return
		fi
		if [ "$2" == "lock" ];then
			say "Manually Locking The Laboratory"
			touch $PUTIN/lab/lock
			return
		fi
		printf "putin lab status\nputin lab lock\nputin lab unlock\n"
	fi
	printf "putin help\nputin create\nputin remove\nputin list\nputin lab\n"
}


