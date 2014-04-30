import QtQuick 2.0;
import Sailfish.Silica 1.0;
import "../components";

Page {
    id: page;

    SilicaFlickable {
        anchors.fill: parent;
        anchors.bottomMargin: playground.height;
        contentHeight: column.height;

        PullDownMenu {
            MenuItem {
                text: qsTr ("Show Page 2");
                onClicked: pageStack.push (secondPage);
            }
        }
        Column {
            id: column;
            width: page.width;
            spacing: Theme.paddingLarge;

            PageHeader {
                title: qsTr("Gems");
            }
            Label {
                x: Theme.paddingLarge;
                text: qsTr ("A clone of the popular Bejeweled game.");
                color: Theme.secondaryHighlightColor;
                font.pixelSize: Theme.fontSizeSmall;
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
