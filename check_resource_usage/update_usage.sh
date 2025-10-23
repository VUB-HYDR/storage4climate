#!/bin/bash


# List of project names to iterate over
project_names=("2022_201" "2022_202" "2022_203" "2022_204" "2022_205")

# Ensure the script is run from the correct directory
cd "$(dirname "$0")"

# Iterate over each project name
for project_name in "${project_names[@]}"; do
    echo "Processing project: $project_name"

    # Get the CSV file from the project
    file="/dodrio/scratch/projects/$project_name/.resource_app.usage.export.csv"
    git_dir=$(git rev-parse --show-toplevel)
    input_file="$git_dir/check_resource_usage/VSC_monitoring/input/usage_$(date +"%Y%m%d")_${project_name}.csv"

    # Copy the file
    cp "$file" "$input_file"

    # Remove all lines before the line containing "Project Usages" but keep the line itself
    #sed -i '1,/Project Usages/{/Project Usages/!d}' "$input_file"

    echo "Copied project: $project_name"

    # Add and commit the changes
    git pull
    git add $input_file

done

git commit -m "Add usage data for all projects"
git push

#A github action will run python script and update the usage.
