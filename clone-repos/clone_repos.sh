#!/bin/bash

check_dependencies() {
	jq_dependency="jq"
	curl_dependency="curl"


	printf "Checking for $jq_dependency and $curl_dependency...\n\n"

	# check if jq is already installed on system
	if which "$jq_dependency" &> /dev/null; then
		echo "$jq_dependency present" &> /dev/null
	else
		read -p "$jq_dependency not found will you like to install it ? (y/n)" install_jq

		if [ $install_jq = "y" ]; then
			sudo apt install $jq_dependency
			printf "\nfinishd installing $jq_dependency"
			sleep 2
			clear
		else
			echo "$jq_dependency is required for parsing JSON response. Ending session"
			exit 1
		fi
	fi

	# check if curl is already installed on system
	if which "$curl_dependency" &> /dev/null; then
		echo "$curl_dependency present" &> /dev/null
	else
		read -p "'$curl_dependency' not found will you like to install it ? (y/n)" install_curl

		if [ $install_curl == "y" ]; then
			sudo apt install $curl_dependency
			printf "\nfinished installing $curl_dependency"
			sleep 2
			clear
		else
			echo "'$curl_dependency' is required for api call. Ending session"
			exit 1
		fi
	fi
	
	printf "All dependencies are present.\n\n"
}

check_dependencies

# check if user provided cridentials as command line arguements if not request for them
if [ ?# -ne 2 ]; then
	read -p "Enter your github user name: " user_name
	read -p "Enter your github access token: " user_token
else
	user_name="$1"
	user_token="$2"
fi

printf "\n\n"

# using the github api to get list of public repos
printf "Making api request to api.github.com ...\n\n"
api_response=$(curl -L -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $user_token" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/users/$user_name/repos)

# check if api request went through
if [ $? -eq 0 ]; then
	# verify api response for error messages
	if echo "$api_response" | jq -e '.message' &>/dev/null; then
		echo "Error: $(echo "$api_response" | jq -r '.message')"
	else
		clear
		printf "Your repositories will be cloned in the current directory: "
		pwd
		printf "Starting cloning process...\n"

		repo_names="$(echo "$api_response" | jq -r '.[].name')"
		
		for repo_name in $repo_names; do
			printf "\n\n"
			read -p "Do you want to clone the repository '$repo_name' ? (y/n) " confirm_repo_clone

			if [ "$confirm_repo_clone" = "y" ]; then
				echo "cloning '$repo_name'..."
				git clone https://$user_token@github.com/$user_name/$repo_name.git
			fi
		done
	fi
fi

printf "\nProgram completed."
exit 0
