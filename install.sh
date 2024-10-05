sudo docker build . -t xmousepasteblock --progress=plain
existing_id=$(sudo docker ps -aq --filter "name=image-name")
[ -n "$existing_id" ] && sudo docker rm -v "$existing_id"
id=$(sudo docker create xmousepasteblock /bin/sh)
trap "printf 'Deleting temporary container: ' && sudo docker rm -v $id" EXIT
/usr/bin/rm -fv xmousepasteblock
echo 'Exporting binary: /xmousepasteblock -> ./xmousepasteblock.tar'
sudo docker cp "$id:/xmousepasteblock" - > xmousepasteblock.tar
tar -xvf xmousepasteblock.tar
/usr/bin/rm -fv xmousepasteblock.tar
