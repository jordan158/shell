cat /root/expect/ip1.txt | while read line 
do
ip=$line
if [ -z `ssh-keygen -F $IP` ]; then
  ssh-keyscan -H $IP >> ~/.ssh/known_hosts
fi
done
