rm -rf ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
read -p "Enter github email : " email
echo "Using email $email"
ssh-keygen -t rsa -b 4096 -C "$email"
ssh-add ~/.ssh/id_rsa
pub=`cat ~/.ssh/id_rsa.pub`
read -p "Enter key name github label: " keyname
echo "Using a token provided"
read -p "Enter github personal access token with public key admin https://github.com/settings/tokens: " token
echo "Using a token provided"

curl -X POST -H "Authorization: token $token" --data "{\"title\":\"$keyname\",\"key\":\"$pub\"}" https://api.github.com/user/keys