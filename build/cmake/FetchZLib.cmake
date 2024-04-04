include(FetchContent)

FetchContent_Declare(
        zlib
        GIT_REPOSITORY ${ZLIB_REPOSITORY}
        GIT_TAG ${ZLIB_TAG}
)

FetchContent_GetProperties(zlib)
if(NOT zlib_POPULATED)
    FetchContent_Populate(zlib)
    add_subdirectory("${zlib_SOURCE_DIR}" "${zlib_BINARY_DIR}")
    message("zlib_POPULATED ${zlib_SOURCE_DIR} ${zlib_BINARY_DIR}")
endif()