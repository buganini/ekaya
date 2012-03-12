CMAKE_MINIMUM_REQUIRED(VERSION 2.6.0 FATAL_ERROR)

project(winkmfl)

enable_language(CXX)

include_directories(${PROJECT_SOURCE_DIR} 
	${PROJECT_SOURCE_DIR}/../../libxml2
	${PROJECT_SOURCE_DIR}/../../libxml2/include
	${win_iconv_SOURCE_DIR}
	)

add_custom_target(xml2_headers
	COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SOURCE_DIR}/config.h ${PROJECT_BINARY_DIR}
	)

add_library(xml2 SHARED
		../../libxml2/SAX.c
		../../libxml2/entities.c
		../../libxml2/encoding.c
		../../libxml2/error.c
		../../libxml2/parserInternals.c
		../../libxml2/parser.c
		../../libxml2/tree.c
		../../libxml2/hash.c
		../../libxml2/list.c
		../../libxml2/xmlIO.c
		../../libxml2/xmlmemory.c
		../../libxml2/uri.c
		../../libxml2/valid.c
		../../libxml2/xlink.c
		../../libxml2/HTMLparser.c
		../../libxml2/HTMLtree.c
		../../libxml2/debugXML.c
		../../libxml2/xpath.c
		../../libxml2/xpointer.c
		../../libxml2/xinclude.c
		../../libxml2/nanohttp.c
		../../libxml2/nanoftp.c
		../../libxml2/DOCBparser.c
		../../libxml2/catalog.c
		../../libxml2/globals.c
		../../libxml2/threads.c
		../../libxml2/c14n.c
		../../libxml2/xmlstring.c
		../../libxml2/xmlregexp.c
		../../libxml2/xmlschemas.c
		../../libxml2/xmlschemastypes.c
		../../libxml2/xmlunicode.c
		../../libxml2/xmlreader.c
		../../libxml2/relaxng.c
		../../libxml2/dict.c
		../../libxml2/SAX2.c
		../../libxml2/xmlwriter.c
		../../libxml2/legacy.c
		../../libxml2/chvalid.c
		../../libxml2/pattern.c
		../../libxml2/xmlsave.c
		../../libxml2/xmlmodule.c
		../../libxml2/schematron.c
	)

add_dependencies(xml2 xml2_headers iconv)
target_link_libraries(xml2 iconv ws2_32)

# install(TARGETS winkmfl RUNTIME DESTINATION bin LIBRARY DESTINATION lib)
