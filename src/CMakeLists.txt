
#Here we're including the Vala package from ../cmake
find_package(Vala REQUIRED)

#Now we're including the version module to ensure we have a compatible version
include(ValaVersion)
ensure_vala_version("0.11.3" MINIMUM)

#Now we're including the precompile modules to set things up.
include(ValaPrecompile)


#We're going to load the PkgConfig module from ../cmake
#We do this to ensure we can include required modules.
#PkgConfig handles all of the querying of packages for us.
#It finds their directories, versions, and if they're installed.
find_package(PkgConfig)

#Now we're declaring GTK+ 3 and Granite as our REQUIRE dependancies.
#If PkgConfig can't find these, you need to install them in Step 1.
pkg_check_modules(DEPS REQUIRED gtk+-3.0 granite)

#Now we're going to ready the libraries and get their directories to include them.
set(CFLAGS
    ${DEPS_CFLAGS} ${DEPS_CFLAGS_OTHER}
)
set(LIB_PATHS
    ${DEPS_LIBRARY_DIRS}
)
link_directories(${LIB_PATHS})


#Here is where vala precompiles all the *.vala files into *.c files.
#Then we compule the *.c files to turn them into a true executable.
add_definitions(${CFLAGS})
vala_precompile(VALA_C
    main.vala
    Core/Canvas.vala
    Core/Image.vala
    Core/Palette.vala
    Views/Welcome.vala
    Views/NewImage.vala
    Views/Window.vala
    Views/WindowToolbar.vala
    Views/ActionToolbar.vala
    Views/StatusToolbar.vala
    Views/Workspace.vala
    Views/DrawTools.vala
    Views/ColorTools.vala
    Views/ToolsPane.vala
    Views/Tools/Tool.vala
    Views/Tools/Brush.vala
    Widgets/Tools.vala
    Widgets/Toolbar.vala
    Widgets/ColorIcon.vala
PACKAGES
    gtk+-3.0
    granite
OPTIONS
    --thread)

#Here we define our executable name.
add_executable(Draw
    ${VALA_C} )

#We need to link the libraries with our Executable.
target_link_libraries(Draw ${DEPS_LIBRARIES})
