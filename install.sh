FILES=`find sh -type f -name "*.sh"`

for FILE in ${FILES[@]};do
	FILE_PATH="${PWD}/${FILE}"
	sudo install "${FILE_PATH}" /etc/profile.d/
done
