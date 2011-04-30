set(DOC_DISABLED FALSE)
if(NOT QT_MOBILITY_SRC_DIR)
    message(WARNING "QT_MOBILITY_SRC_DIR variable not set, apidoc generation targets disabled.")
    set(DOC_DISABLED TRUE)
endif()

find_program(DOT_EXEC dot)
if(NOT DOT_EXEC)
    message(WARNING "Missing graphviz tool (dot), apidoc generation targets disabled.")
    set(DOC_DISABLED TRUE)
endif()

if(NOT DOC_DISABLED)
    set(DOC_DATA_DIR "${CMAKE_CURRENT_BINARY_DIR}/qdoc3-output")


    #copy pysidem.qdocconf to mobility source dir.
    configure_file("pysidem.qdocconf.in" "pysidem.qdocconf" @ONLY)
    add_custom_target(qdoc3
                      COMMAND qdoc3 pysidem.qdocconf
                      COMMENT "Running qdoc3 against QtMobility source code..."
                      SOURCE "pysidem.qdocconf")

    add_custom_target(apidoc
                      COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}/rst
                      COMMAND sphinx-build -b html  ${CMAKE_CURRENT_BINARY_DIR}/rst html
                     )

    #create conf.py based on conf.py.in
    configure_file("conf.py.in" "rst/conf.py" @ONLY)
    configure_file(typesystem_doc.xml.in typesystem_doc.xml @ONLY)

    set(mobility_TYPESYSTEM_PATH "${PYSIDE_TYPESYSTEMS}")
    set(mobility_TYPESYSTEM_PATH "${mobility_TYPESYSTEM_PATH}${PATH_SEP}${Contacts_SOURCE_DIR}/../Bearer")
    set(mobility_TYPESYSTEM_PATH "${mobility_TYPESYSTEM_PATH}${PATH_SEP}${Contacts_SOURCE_DIR}")
    set(mobility_TYPESYSTEM_PATH "${mobility_TYPESYSTEM_PATH}${PATH_SEP}${Connectivity_SOURCE_DIR}")
    set(mobility_TYPESYSTEM_PATH "${mobility_TYPESYSTEM_PATH}${PATH_SEP}${Feedback_SOURCE_DIR}")
    set(mobility_TYPESYSTEM_PATH "${mobility_TYPESYSTEM_PATH}${PATH_SEP}${Gallery_SOURCE_DIR}")
    set(mobility_TYPESYSTEM_PATH "${mobility_TYPESYSTEM_PATH}${PATH_SEP}${Location_SOURCE_DIR}")
    set(mobility_TYPESYSTEM_PATH "${mobility_TYPESYSTEM_PATH}${PATH_SEP}${Messaging_SOURCE_DIR}")
    set(mobility_TYPESYSTEM_PATH "${mobility_TYPESYSTEM_PATH}${PATH_SEP}${MultimediaKit_SOURCE_DIR}")
    set(mobility_TYPESYSTEM_PATH "${mobility_TYPESYSTEM_PATH}${PATH_SEP}${Organizer_SOURCE_DIR}")
    set(mobility_TYPESYSTEM_PATH "${mobility_TYPESYSTEM_PATH}${PATH_SEP}${PublishSubscribe_SOURCE_DIR}")
    set(mobility_TYPESYSTEM_PATH "${mobility_TYPESYSTEM_PATH}${PATH_SEP}${Sensors_SOURCE_DIR}")
    set(mobility_TYPESYSTEM_PATH "${mobility_TYPESYSTEM_PATH}${PATH_SEP}${ServiceFramework_SOURCE_DIR}")
    set(mobility_TYPESYSTEM_PATH "${mobility_TYPESYSTEM_PATH}${PATH_SEP}${SystemInfo_SOURCE_DIR}")
    set(mobility_TYPESYSTEM_PATH "${mobility_TYPESYSTEM_PATH}${PATH_SEP}${Versit_SOURCE_DIR}")

    set(mobility_INCLUDE_DIR "${QT_INCLUDE_DIR}")
    # Put Bearer headers before Qt ones.
    set(mobility_INCLUDE_DIR "${QT_MOBILITY_CONTACTS_INCLUDE_DIR}/../QtBearer${PATH_SEP}${mobility_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${mobility_SOURCE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_PARENT_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_CONTACTS_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_CONNECTIVITY_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_FEEDBACK_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_GALLERY_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_LOCATION_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_MESSAGING_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_MULTIMEDIAKIT_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_ORGANIZER_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_PUBLISHSUBSCRIBE_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_SENSORS_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_SERVICEFRAMEWORK_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_SYSTEMINFO_INCLUDE_DIR}")
    set(mobility_INCLUDE_DIR "${mobility_INCLUDE_DIR}${PATH_SEP}${QT_MOBILITY_VERSIT_INCLUDE_DIR}")



    add_custom_target("docrsts"
        COMMAND ${GENERATORRUNNER_BINARY} --generator-set=qtdoc
                ${CMAKE_SOURCE_DIR}/${BINDING_NAME}/global.h
                --include-paths="${mobility_INCLUDE_DIR}"
                --api-version=${SUPPORTED_QT_VERSION}
                --typesystem-paths="${mobility_SOURCE_DIR}${PATH_SEP}${mobility_TYPESYSTEM_PATH}"
                --library-source-dir=${QT_MOBILITY_SRC_DIR}
                --documentation-only
                --documentation-data-dir=${DOC_DATA_DIR}
                --output-directory=${CMAKE_CURRENT_BINARY_DIR}/rst
                --documentation-code-snippets-dir=${CMAKE_CURRENT_SOURCE_DIR}/codesnippets${PATH_SEP}${CMAKE_CURRENT_SOURCE_DIR}/codesnippets/examples
                --documentation-extra-sections-dir=${CMAKE_CURRENT_SOURCE_DIR}/extras
                ${CMAKE_CURRENT_BINARY_DIR}/typesystem_doc.xml
        WORKING_DIRECTORY ${${module}_SOURCE_DIR}
        COMMENT "Running generator to generate documentation..."
    )

    #copy pysidem.qdocconf to mobility source dir.
    #configure_file("pysidem.qdocconf" "${QT_MOBILITY_SRC_DIR}/doc/src/pysidem.qdocconf" @ONLY)
    add_dependencies(apidoc docrsts)
    add_dependencies(docrsts qdoc3)

    #install files
    add_custom_target(apidocinstall
        COMMAND mkdir -p ${CMAKE_INSTALL_PREFIX}/share/doc/${BINDING_NAME} && cp -rv ${CMAKE_BINARY_DIR}/apidoc/* ${CMAKE_INSTALL_PREFIX}/share/doc/${BINDING_NAME}
    )

    add_dependencies(apidocinstall apidoc)

endif()
