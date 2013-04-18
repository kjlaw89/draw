
# We define the minimum cmake. This is standard for Elementary OS
cmake_minimum_required (VERSION 2.8)

#We define the minimum policy version
cmake_policy(VERSION 2.8)


#We define out project name.
project(Draw)


#Here we load the modules we downloaded earlier and placed into the ./cmake directory
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake )

#Here we add the src directory. CMake will look for the CMakeLists.txt in this folder 
#and work from there
add_subdirectory (src)
