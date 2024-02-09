FILES=`find sh -type f -name "*.sh"`

for FILE in ${FILES[@]};do
	FILE_PATH="${PWD}/${FILE}"
	sudo rm /etc/profile.d/"$(echo $FILE | rev | cut -f1 -d '/' | rev | tr -d '\n' | tr -d '\r')"
	sudo install "${FILE_PATH}" /etc/profile.d/
done
