# ```cmake
cmake_minimum_required(VERSION 3.21)
project(ChatAI VERSION 0.1 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Enable Qt-specific features
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Find Qt6 modules
find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Widgets
    Qml
    Quick
    QuickControls2
    Sql
    Network
    Concurrent
    Xml
    # WebSockets
    # WebEngineCore
    # WebEngineWidgets
    # WebChannel
)

# Optional: Include Test module only if needed
if(BUILD_TESTING)
    find_package(Qt6 REQUIRED COMPONENTS Test)
endif()

# Source files
set(SOURCES
    src/main.cpp
    # src/MainWindow.cpp
    # src/DatabaseHandler.cpp
    # src/NetworkManager.cpp
    # src/QmlInterface.cpp
    # ui/MainWindow.ui
)

# Resource files
# set(RESOURCES
#     qml/qml.qrc
# )

# Create the executable
qt_add_executable(ChatAI ${SOURCES} ${RESOURCES})

# Define QML module
# qt_add_qml_module(ChatAI
#     URI ChatAI
#     VERSION 1.0
#     QML_FILES
#         qml/main.qml
#         qml/ChatView.qml
#     SOURCES
#         src/QmlInterface.h
#         src/QmlInterface.cpp
# )

# Link Qt6 libraries
target_link_libraries(ChatAI PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Sql
    Qt6::Network
    Qt6::Concurrent
    Qt6::Xml
    # Qt6::WebSockets
    # Qt6::WebEngineCore
    # Qt6::WebEngineWidgets
    # Qt6::WebChannel
)

# Include directories
target_include_directories(ChatAI PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

# Platform-specific settings
if(WIN32)
    set_target_properties(ChatAI PROPERTIES
        WIN32_EXECUTABLE TRUE
    )
    # Optional: Copy Qt DLLs for deployment
    find_program(WINDEPLOYQT_EXECUTABLE windeployqt HINTS "${Qt6_DIR}/bin")
    if(WINDEPLOYQT_EXECUTABLE)
        add_custom_command(TARGET ChatAI POST_BUILD
            COMMAND ${WINDEPLOYQT_EXECUTABLE} $<TARGET_FILE:ChatAI>
            COMMENT "Running windeployqt for Windows deployment"
        )
    endif()
elseif(APPLE)
    set_target_properties(ChatAI PROPERTIES
        MACOSX_BUNDLE TRUE
        MACOSX_BUNDLE_GUI_IDENTIFIER com.example.chatai
        MACOSX_BUNDLE_BUNDLE_NAME "ChatAI"
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION}
    )
    # Optional: Run macdeployqt for deployment
    find_program(MACDEPLOYQT_EXECUTABLE macdeployqt HINTS "${Qt6_DIR}/bin")
    if(MACDEPLOYQT_EXECUTABLE)
        add_custom_command(TARGET ChatAI POST_BUILD
            COMMAND ${MACDEPLOYQT_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/ChatAI.app
            COMMENT "Running macdeployqt for macOS deployment"
        )
    endif()
endif()

# Optional: Enable testing
if(BUILD_TESTING)
    enable_testing()
    add_subdirectory(tests)
endif()

# Install the executable
install(TARGETS ChatAI
    RUNTIME DESTINATION bin
    BUNDLE DESTINATION .
)