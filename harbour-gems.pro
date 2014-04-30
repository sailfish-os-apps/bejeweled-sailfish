# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-gems

CONFIG += sailfishapp

SOURCES += src/harbour-gems.cpp

OTHER_FILES += qml/harbour-gems.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-gems.changes.in \
    rpm/harbour-gems.spec \
    rpm/harbour-gems.yaml \
    harbour-gems.desktop \
    qml/components/gems.svg \
    qml/components/gem6.png \
    qml/components/gem5.png \
    qml/components/gem4.png \
    qml/components/gem3.png \
    qml/components/gem2.png \
    qml/components/gem1.png \
    qml/components/Playground.qml \
    qml/components/Gem.qml \
    translations/harbour-gems.ts

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

TRANSLATIONS +=

