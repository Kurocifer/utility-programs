# clone_repos
This is a Bash script that helps you clone all your desired public github repositories to your local machine

## Why

After intalling a new system on my computer, just felt lazy at the thought of having to clone 
each repo individually and was also thrilled enough to write this script tho it took me way longer to write it than it should have taken to clone individually.

## Features

- Supports fetching repositories for a GitHub username
- Prompts the user to confirm whether they want to clone each repository name

## Prerequisites

- Bash shell
- `curl` command-line tool
- `jq` JSON processing tool

## Usage

1. Clone the repository
2. Change to the project directory
3. Run the script (./clone_repos.sh), providing your GitHub username and personal access token as command-line arguments in this order

Alternatively, if you don't want to provide the username and token as arguments, you will later be prompted for them.

## Contributing

If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request.
