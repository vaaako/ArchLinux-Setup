if [ ! -d config_files ] || [ ! -f config_files/bashrc_root.txt ]; then
	echo "~> config_files folder or bashrc_root.txt file not found"
	exit
fi

sudo cp config_files/bashrc_root.txt /root/.bashrc
echo -e "~> .bashrc moved succesfully! \n~> Test it running \"sudo su\""
