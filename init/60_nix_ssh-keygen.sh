key_directory="${HOME}/.ssh/keys/"
key_titles=( id_rsa github bitbucket llnl gitlab )
e_header "Creating ssh keys (${key_titles[@]}) in ${key_directory} (if they don't already exist)"
mkdir -p ${key_directory}

for key_title in ${key_titles[@]}; do
    key_file="${key_directory}/${key_title}"
    if [ ! -f ${key_file} ]; then
        echo "Creating ${key_file}"
        ssh-keygen -t rsa -b 4096 -f ${key_file} -N "" -q
    else
        echo "Skipping ${key_file}, already exists"
    fi
done
