include(FetchContent)

FetchContent_Declare(
        qsupermacros
        GIT_REPOSITORY ${QSUPERMACROS_REPOSITORY}
        GIT_TAG ${QSUPERMACROS_TAG}
)

set(QSUPERMACROS_FOLDER_PREFIX "Dependencies" CACHE STRING "")

FetchContent_MakeAvailable(qsupermacros)
