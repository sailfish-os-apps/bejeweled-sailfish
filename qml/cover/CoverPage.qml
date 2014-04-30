import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    id: cover;

    Column {
        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
            margins: Theme.paddingLarge;
        }

        Label {
            text: "Gems";
            color: Theme.highlightColor;
            font.pixelSize: Theme.fontSizeSmall;
            anchors.horizontalCenter: parent.horizontalCenter;
        }
        Label {
            text: qsTr ("%1 pts").arg (currentPlayground ? currentPlayground.score : "");
            color: Theme.primaryColor;
            visible: currentPlayground;
            font.pixelSize: Theme.fontSizeLarge;
            anchors.horizontalCenter: parent.horizontalCenter;
        }
    }
    CoverActionList {
        enabled: currentPlayground;
        iconBackground: false;

        CoverAction {
            iconSource: "image://theme/icon-cover-sync";
            onTriggered: { currentPlayground.reset (); }
        }
    }
}


