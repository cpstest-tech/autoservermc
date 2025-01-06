echo " https://t.me/cpstestlounge https://tiktok.com/@cpstest_ "
echo " "
echo "Auto Minecraft Hosting for mobile "
USE_Paper=true
read -p "Use ngrok (reccomended) ([yes]/no)?" USE_NGROK
USE_NGROK=${USE_NGROK:-yes}

if [ "$USE_NGROK" = "yes" ] ; then
  read -p "ngrok authtoken (REQUIRED see https://dashboard.ngrok.com/get-started/your-authtoken): " AUTHTOKEN
  read -p "ngrok region (us/[eu]/ap/au/in): " NGROK_REGION
  NGROK_REGION=${NGROK_REGION:-eu}
fi

DEF_Paper_INSTALLER="https://api.papermc.io/v2/projects/paper/versions/1.21.3/builds/82/downloads/paper-1.21.3-82.jar"
read -p "Custom Paper installer (leave blank for default 1.21: $DEF_Paper_INSTALLER)? " Paper_SERVER
Paper_SERVER=${Paper_SERVER:-$DEF_Paper_INSTALLER}

EXEC_SERVER_NAME="minecraft_server.jar"

##### INSTALLATIONS XIMI #####

pkg install openjdk-17 zip unzip -y
echo "Loading Minecraft Server"
mkdir AutoHostingMobile
cd AutoHostingMobile
echo "eula=true" > eula.txt
wget $Paper_SERVER
installer_jar=$(echo $Paper_SERVER | rev | cut -d '/' -f 1 | rev)
# exec_jar=$(echo $installer_jar | sed -e 's/-installer//g')
java -jar $installer_jar --installServer
# mv $exec_jar $EXEC_SERVER_NAME
# rm $installer_jar
echo "cd AutoHostingMobile && java -Xmx1G -jar paper-1.20.4-405.jar nogui" > ../start.sh
chmod +x ../start.sh

# NGROK
if [ "$USE_NGROK" = "yes" ] ; then
  echo "STATUS: setting up ngrok"
  cd ..
  wget -O ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.tgz && unzip ngrok.tgz && chmod +x ngrok
  echo "./ngrok tcp --region=$NGROK_REGION 25565" > ip.sh
  chmod +x ip.sh
  ./ngrok authtoken $AUTHTOKEN
fi

echo " "
echo "Server is complete!"
echo "Run ./start.sh here to start minecraft server, "
echo "open a new session by swiping on the left, "
echo "and run ./ip.sh for starting port forwarding"
echo " "
