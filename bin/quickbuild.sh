# We need to make our build directory for all of our temp files.
rm -r ../build
mkdir ../build

#Enter the build Directory
cd ../build

#Now we initiate cmake in this dir
cmake ..

#Next we build the source files!
make

#Next we copy the executable to our root project file.
cp ./src/Draw ../bin/Draw
mkdir ~/.draw/
cp -rf ../bin/images ~/.draw/
cp -rf ../bin/palettes ~/.draw/
cp ../bin/draw.css ~/.draw/draw.css
rm -rf /opt/Draw
mkdir /opt/Draw
cp -r ../bin/* /opt/Draw
rm -f /usr/bin/Draw
ln -s /opt/Draw/Draw /usr/bin/Draw
rm /opt/Draw/quickbuild.sh