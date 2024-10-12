#!/bin/bash

set -ex
export PS4="\e[32m+\e[0m "

function print_stuff() {
  for i in {9..1}
  do
    echo "$i..."
    sleep "0.$i"
  done

}

print_stuff

echo "Start collapsible section"

# Start a section that GitLab CI should detect as collapsible
echo -e "\e[0Ksection_start:$(date +%s):my_custom_section[collapsed=true]\r\e[0KMy Custom Section"

print_stuff

# End GitLab CI collapsible section
echo -e "\e[0Ksection_end:$(date +%s):my_custom_section\r\e[0K"

print_stuff
