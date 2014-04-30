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
