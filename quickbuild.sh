# We need to make our build directory for all of our temp files.
rm -r ./build
mkdir ./build

# Enter the build Directory
cd ./build

# Now we initiate cmake in this dir
cmake ..


# Next we build the source files!
make

# Move the built file back to the main folder (and run)
mv ./src/Draw ../draw
cd ..

# Compile resources files
glib-compile-resources --target=appresources --sourcedir=./resources ./resources/app.gresource.xml

./draw