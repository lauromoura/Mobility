INCLUDE(FindQt4)

#set(MOBILITY_CONFIG_MKSPECS_FILE "")
#IF(EXISTS "${QT_MKSPECS_DIR}/features/mobilityconfig.prf")
#    set(MOBILITY_CONFIG_MKSPECS_FILE "${QT_MKSPECS_DIR}/features/mobilityconfig.prf")
#ELSEIF(EXISTS "${QT_MKSPECS_DIR}/features/mobility.prf")
    set(MOBILITY_CONFIG_MKSPECS_FILE "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/mobilityconfig.prf")
#ENDIF()

macro(export_component component)
    IF(NOT ${MOBILITY_CONFIG_MKSPECS_FILE} STREQUAL "")
        FILE(READ ${MOBILITY_CONFIG_MKSPECS_FILE} MOBILITY_FILE_CONTENTS)
        STRING(TOLOWER ${component} _COMPONENT)
        IF(${MOBILITY_FILE_CONTENTS} MATCHES "MOBILITY_CONFIG=.*${_COMPONENT}.*")
            STRING(TOUPPER ${component} _COMPONENT)
            SET(QT_MOBILITY_${_COMPONENT}_FOUND 1)
            SET(QT_MOBILITY_${_COMPONENT}_INCLUDE_DIR ${QT_MOBILITY_PARENT_INCLUDE_DIR}/Qt${component})
            SET(QT_MOBILITY_${_COMPONENT}_LIBRARY Qt${component})
        ENDIF()
    ENDIF()
endmacro()

if(EXISTS "${QT_MKSPECS_DIR}/features/mobility12.prf")
    set(MOBILITY_PRF_FILE "${QT_MKSPECS_DIR}/features/mobility12.prf")
elseif(EXISTS "${QT_MKSPECS_DIR}/features/mobility11.prf")
    set(MOBILITY_PRF_FILE "${QT_MKSPECS_DIR}/features/mobility11.prf")
elseif(EXISTS "${QT_MKSPECS_DIR}/features/mobility.prf")
    set(MOBILITY_PRF_FILE "${QT_MKSPECS_DIR}/features/mobility.prf")
endif()

IF(DEFINED MOBILITY_PRF_FILE)
    FILE(READ ${MOBILITY_PRF_FILE} MOBILITY_FILE_CONTENTS)

    STRING(REGEX MATCH "MOBILITY_PREFIX=([^\n]+)" QT_MOBILITY_PREFIX "${MOBILITY_FILE_CONTENTS}")
    SET(QT_MOBILITY_PREFIX ${CMAKE_MATCH_1})

    STRING(REGEX MATCH "MOBILITY_INCLUDE=([^\n]+)" QT_MOBILITY_INCLUDE_DIR "${MOBILITY_FILE_CONTENTS}")
    SET(QT_MOBILITY_INCLUDE_DIR ${CMAKE_MATCH_1})

    STRING(REGEX MATCH "MOBILITY_LIB=([^\n]+)" "\\1" QT_MOBILITY_LIBRARY "${MOBILITY_FILE_CONTENTS}")
    SET(QT_MOBILITY_LIBRARY_DIR ${CMAKE_MATCH_1})

    #VERSION
    IF(NOT ${MOBILITY_CONFIG_MKSPECS_FILE} STREQUAL "")
        FILE(READ ${MOBILITY_CONFIG_MKSPECS_FILE} MOBILITY_CONFIG_FILE_CONTENTS)
        STRING(REGEX MATCH "MOBILITY_VERSION = ([^\n]+)" QT_MOBILITY_VERSION "${MOBILITY_CONFIG_FILE_CONTENTS}")
        SET(QT_MOBILITY_VERSION ${CMAKE_MATCH_1})

        STRING(REGEX MATCH "MOBILITY_MAJOR_VERSION = ([^\n]+)" QT_MOBILITY_MAJOR_VERSION "${MOBILITY_CONFIG_FILE_CONTENTS}")
        SET(QT_MOBILITY_MAJOR_VERSION ${CMAKE_MATCH_1})

        STRING(REGEX MATCH "MOBILITY_MINOR_VERSION = ([^\n]+)" QT_MOBILITY_MINOR_VERSION "${MOBILITY_CONFIG_FILE_CONTENTS}")
        SET(QT_MOBILITY_MINOR_VERSION ${CMAKE_MATCH_1})

        STRING(REGEX MATCH "MOBILITY_PATCH_VERSION = ([^\n]+)" QT_MOBILITY_PATCH_VERSION "${MOBILITY_CONFIG_FILE_CONTENTS}")
        SET(QT_MOBILITY_PATCH_VERSION ${CMAKE_MATCH_1})
    ELSE()
        SET(QT_MOBILITY_VERSION 1.0.0)
        SET(QT_MOBILITY_MAJOR_VERSION 1)
        SET(QT_MOBILITY_MINOR_VERSION 0)
        SET(QT_MOBILITY_PATCH_VERSION 0)
    ENDIF()

    SET(QT_MOBILITY_PARENT_INCLUDE_DIR ${QT_MOBILITY_INCLUDE_DIR})
    SET(QT_MOBILITY_INCLUDE_DIR ${QT_MOBILITY_INCLUDE_DIR}/QtMobility)

    IF(QtMobility_FIND_VERSION_EXACT)
        IF(QT_MOBILITY_VERSION VERSION_EQUAL QtMobility_FIND_VERSION)
            SET(QT_MOBILITY_FOUND TRUE)
        ELSE()
            SET(QT_MOBILITY_FOUND FALSE)
            IF(QT_MOBILITY_VERSION VERSION_LESS QtMobility_FIND_VERSION)
                SET(QT_MOBILITY_TOO_OLD TRUE)
            ELSE()
                SET(QT_MOBILITY_TOO_NEW TRUE)
            ENDIF()
        ENDIF()
    ELSE()
        IF(QT_MOBILITY_VERSION VERSION_LESS QtMobility_FIND_VERSION)
            SET(QT_MOBILITY_FOUND FALSE)
            SET(QT_MOBILITY_TOO_OLD TRUE)
        ELSE()
            SET(QT_MOBILITY_FOUND TRUE)
        ENDIF()
    ENDIF()
ELSE()
    SET(QT_MOBILITY_FOUND NOTFOUND)
    SET(QT_MOBILITY_PREFIX NOTFOUND)
    SET(QT_MOBILITY_INCLUDE NOTFOUND)
    SET(QT_MOBILITY_LIB NOTFOUND)
ENDIF()

IF(NOT QT_MOBILITY_FOUND)
    if(QT_MOBILITY_TOO_OLD)
        MESSAGE(FATAL_ERROR "The installed QtMobility version ${QT_MOBILITY_VERSION} it too old, version ${QtMobility_FIND_VERSION} is required.")
    ELSEIF(QT_MOBILITY_TOO_NEW)
        MESSAGE(FATAL_ERROR "The installed QtMobility version ${QT_MOBILITY_VERSION} it too new, version ${QtMobility_FIND_VERSION} is required.")
    ELSE()
        MESSAGE(FATAL_ERROR "QtMobility not found.")
    ENDIF()
ELSE()
    export_component(Bearer)
    export_component(Feedback)
    export_component(Gallery)
    export_component(PublishSubscribe)
    export_component(Location)
    export_component(Organizer)
    export_component(ServiceFramework)
    export_component(SystemInfo)
    export_component(MultimediaKit)
    export_component(Contacts)
    export_component(Messaging)
    export_component(Versit)
    export_component(VersitOrganizer)
    export_component(Sensors)
ENDIF()
