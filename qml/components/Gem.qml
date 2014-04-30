import QtQuick 2.0

Item {
    width: parent.width;
    height: parent.height;

    property int   type  : -1;

    Image {
        id: img;
        source: "gem%1.png".arg (type);
        width: sourceSize.width;
        height: sourceSize.height;
        fillMode: Image.Pad;
        anchors.centerIn: parent;
    }
}
