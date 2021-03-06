# Find Wt includes and libraries
#
# This script sets the following variables:
#
#  Wt_INCLUDE_DIR
#  Wt_LIBRARIES  - Release libraries
#  Wt_FOUND  - True if release libraries found
#  Wt_DEBUG_LIBRARIES  - Debug libraries
#  Wt_DEBUG_FOUND  - True if debug libraries found
#
# To direct the script to a particular Wt installation, use the
# standard cmake variables CMAKE_INCLUDE_PATH and CMAKE_LIBRARY_PATH
#
# To use this script to find Wt, when using the new style for include files:
#   #include <Wt/WLineEdit>
#   #include <Wt/Ext/LineEdit>
#   #include <Wt/Chart/WPieChart>
#
# include the following CMake snippet in your project:
#
#  FIND_PACKAGE( Wt REQUIRED )
#  INCLUDE_DIRECTORIES( ${Wt_INCLUDE_DIR} )
#  TARGET_LINK_LIBRARIES( yourexe
#    ${Wt_DEBUG_LIBRARY}        # or {Wt_LIBRARY}
#    ${Wt_HTTP_DEBUG_LIBRARY}   # or {Wt_HTTP_LIBRARY}
#    ${Wt_EXT_DEBUG_LIBRARY}    # or {Wt_EXT_LIBRARY}
#  )
#
# To use this script to find Wt, when using the old include style:
#   #include <WLineEdit>
#   #include <Ext/LineEdit>
#   #include <Chart/WPieChart>
# style of include files, change the INCLUDE_DIRECTORIES statement to:
#   INCLUDE_DIRECTORIES( ${Wt_INCLUDE_DIR} ${Wt_INCLUDE_DIR}/Wt )
#
#
#
#
# Copyright (c) 2007, Pau Garcia i Quiles, <pgquiles@elpauer.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

FIND_PATH( Wt_INCLUDE_DIR NAMES Wt/WObject PATHS ENV WT_ROOT PATH PATH_SUFFIXES include wt )

SET(Wt_FIND_COMPONENTS Release Debug)

IF(Wt_INCLUDE_DIR)
    FIND_LIBRARY(Wt_LIBRARY NAMES wt PATHS ENV WT_ROOT PATH PATH_SUFFIXES lib lib-release lib_release)
    FIND_LIBRARY(Wt_DEBUG_LIBRARY NAMES wtd wt PATHS ENV WT_ROOT PATH PATH_SUFFIXES lib libd lib-debug lib_debug HINTS /usr/lib/debug/usr/lib)
    FIND_LIBRARY(Wt_DBO_LIBRARY NAMES wtdbo PATHS ENV WT_ROOT PATH PATH_SUFFIXES lib lib-release lib_release)
    FIND_LIBRARY(Wt_DBO_DEBUG_LIBRARY NAMES wtdbod wtdbo PATHS ENV WT_ROOT PATH PATH_SUFFIXES lib lib-debug lib_debug HINTS /usr/lib/debug/usr/lib)
    
    if (NOT USE_FCGI_CONNECTOR)
        FIND_LIBRARY(Wt_HTTP_LIBRARY NAMES wthttp PATHS ENV WT_ROOT PATH PATH_SUFFIXES lib lib-release lib_release)
        FIND_LIBRARY(Wt_HTTP_DEBUG_LIBRARY NAMES wthttpd wthttp PATHS ENV WT_ROOT PATH PATH_SUFFIXES lib libd lib-debug lib_debug HINTS /usr/lib/debug/usr/lib)
    else (NOT USE_FCGI_CONNECTOR FALSE)
        FIND_LIBRARY(Wt_FCGI_LIBRARY NAMES wtfcgi PATHS ENV WT_ROOT PATH PATH_SUFFIXES lib lib-release lib_release)
        FIND_LIBRARY(Wt_FCGI_DEBUG_LIBRARY NAMES wtfcgid wtfcgi PATHS ENV WT_ROOT PATH PATH_SUFFIXES lib libd lib-debug lib_debug HINTS /usr/lib/debug/usr/lib)
    endif (NOT USE_FCGI_CONNECTOR)
        
    IF (Wt_LIBRARY)
        SET(Wt_FOUND TRUE)
		SET(Wt_FIND_REQUIRED_Release TRUE)
        SET(Wt_LIBRARIES ${Wt_LIBRARY})
    ENDIF(Wt_LIBRARY)

	IF (USE_FCGI_CONNECTOR AND Wt_FCGI_LIBRARY)
        SET(Wt_LIBRARIES ${Wt_LIBRARIES} ${Wt_FCGI_LIBRARY})
    else (USE_FCGI_CONNECTOR AND Wt_FCGI_LIBRARY)
        if (USE_FCGI_CONNECTOR AND NOT Wt_FCGI_LIBRARY)
            MESSAGE(FATAL_ERROR "Could NOT find WtFCGI release libraries (fcgi switch is enabled)")
        endif (USE_FCGI_CONNECTOR AND NOT Wt_FCGI_LIBRARY)
    ENDIF (USE_FCGI_CONNECTOR AND Wt_FCGI_LIBRARY)

    if (NOT USE_FCGI_CONNECTOR AND Wt_HTTP_LIBRARY)
        SET(Wt_LIBRARIES ${Wt_LIBRARIES} ${Wt_HTTP_LIBRARY})
    else (NOT USE_FCGI_CONNECTOR AND Wt_HTTP_LIBRARY)
        if (NOT USE_FCGI_CONNECTOR AND NOT Wt_HTTP_LIBRARY)
            MESSAGE(FATAL_ERROR "Could NOT find WtHTTP release libraries")
        endif (NOT USE_FCGI_CONNECTOR AND NOT Wt_HTTP_LIBRARY)
    endif(NOT USE_FCGI_CONNECTOR AND Wt_HTTP_LIBRARY)

    IF (Wt_DEBUG_LIBRARY)
        SET(Wt_DEBUG_FOUND TRUE)
		SET(Wt_FIND_REQUIRED_Debug TRUE)
        SET(Wt_DEBUG_LIBRARIES ${Wt_DEBUG_LIBRARY})
    ENDIF(Wt_DEBUG_LIBRARY)

	IF (USE_FCGI_CONNECTOR AND Wt_FCGI_DEBUG_LIBRARY)
        SET(Wt_DEBUG_LIBRARIES ${Wt_DEBUG_LIBRARIES} ${Wt_FCGI_DEBUG_LIBRARY})
    else (USE_FCGI_CONNECTOR AND Wt_FCGI_DEBUG_LIBRARY)
        if (USE_FCGI_CONNECTOR AND NOT Wt_FCGI_DEBUG_LIBRARY)
            MESSAGE(FATAL_ERROR "Could NOT find WtFCGI debug libraries (fcgi switch is enabled)")
        endif (USE_FCGI_CONNECTOR AND NOT Wt_FCGI_DEBUG_LIBRARY)
    ENDIF (USE_FCGI_CONNECTOR AND Wt_FCGI_DEBUG_LIBRARY)

    if (NOT USE_FCGI_CONNECTOR AND Wt_HTTP_DEBUG_LIBRARY)
        SET(Wt_DEBUG_LIBRARIES ${WDEBUG_t_LIBRARIES} ${Wt_HTTP_DEBUG_LIBRARY})
    else (NOT USE_FCGI_CONNECTOR AND Wt_HTTP_DEBUG_LIBRARY)
        if (NOT USE_FCGI_CONNECTOR AND NOT Wt_HTTP_DEBUG_LIBRARY)
            MESSAGE(FATAL_ERROR "Could NOT find WtHTTP debug libraries")
        endif (NOT USE_FCGI_CONNECTOR AND NOT Wt_HTTP_DEBUG_LIBRARY)
    endif(NOT USE_FCGI_CONNECTOR AND Wt_HTTP_DEBUG_LIBRARY)

    IF(Wt_FOUND)
        IF (NOT Wt_FIND_QUIETLY)
            MESSAGE(STATUS "Found the Wt libraries at ${Wt_LIBRARIES}")
            MESSAGE(STATUS "Found the Wt headers at ${Wt_INCLUDE_DIR}")
        ENDIF (NOT Wt_FIND_QUIETLY)
    ELSE(Wt_FOUND)
        IF(Wt_FIND_REQUIRED)
            MESSAGE(FATAL_ERROR "Could NOT find Wt")
        ENDIF(Wt_FIND_REQUIRED)
    ENDIF(Wt_FOUND)

    IF(Wt_DEBUG_FOUND)
        IF (NOT Wt_FIND_QUIETLY)
            MESSAGE(STATUS "Found the Wt debug libraries at ${Wt_DEBUG_LIBRARIES}")
            MESSAGE(STATUS "Found the Wt debug headers at ${Wt_INCLUDE_DIR}")
        ENDIF (NOT Wt_FIND_QUIETLY)
    ELSE(Wt_DEBUG_FOUND)
        IF(Wt_FIND_REQUIRED_Debug)
            MESSAGE(FATAL_ERROR "Could NOT find Wt debug libraries")
        ENDIF(Wt_FIND_REQUIRED_Debug)
    ENDIF(Wt_DEBUG_FOUND)
ENDIF( Wt_INCLUDE_DIR )
