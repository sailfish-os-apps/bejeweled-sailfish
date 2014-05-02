import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page;
    Component.onCompleted: { currentPlayground = playground; }

    SilicaFlickable {
        anchors.fill: parent;
        anchors.bottomMargin: playground.height;
        contentHeight: column.height;

        PullDownMenu {
            MenuItem {
                text: qsTr ("Restart game");
                onClicked: { playground.reset (); }
            }
        }
        Column {
            id: column;
            width: page.width;
            spacing: Theme.paddingLarge;

            PageHeader {
                title: qsTr ("Gems");
            }
            Label {
                x: Theme.paddingLarge;
                text: qsTr ("A clone of the popular Bejeweled game.");
                color: Theme.secondaryHighlightColor;
                font.pixelSize: Theme.fontSizeSmall;
            }
            Label {
                text: qsTr ("%1 pts").arg (playground.score);
                color: Theme.primaryColor;
                font.pixelSize: Theme.fontSizeHuge;
                anchors.horizontalCenter: parent.horizontalCenter;
            }
            Label {
                id: lblTime;
                text: {
                    var mins = Math.floor (playground.time / 60);
                    var secs = (playground.time % 60);
                    var ret  = "";
                    if (mins) {
                        ret += "%1 %2  ".arg (mins).arg (mins > 1 ? qsTr ("mins") : qsTr ("min"));
                    }
                    ret += "%1 %2".arg (secs).arg (secs > 1 ? qsTr ("secs") : qsTr ("sec"));
                    return ret;
                }
                color: Theme.primaryColor;
                font.pixelSize: Theme.fontSizeLarge;
                anchors.horizontalCenter: parent.horizontalCenter;
                onTextChanged: SequentialAnimation {
                    PropertyAnimation {
                        target: lblTime;
                        property: "scale";
                        to: 1.25;
                        duration: (playground.time > 4 * 60 ? 50 : 0);
                    }
                    PropertyAnimation {
                        target: lblTime;
                        property: "scale";
                        to: 1.00;
                        duration: (playground.time > 4 * 60 ? 50 : 0);
                    }
                }
            }
        }
    }
    Playground {
        id: playground;
        height: width;
        anchors {
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }
    }
}
