include(FetchContent)

FetchContent_Declare(
        quazip
        GIT_REPOSITORY ${QUAZIP_REPOSITORY}
        GIT_TAG ${QUAZIP_TAG}
)

set(QUAZIP_FOLDER_PREFIX "Dependencies" CACHE STRING "")

FetchContent_MakeAvailable(quazip)
