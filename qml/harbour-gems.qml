import QtQuick 2.0
import Sailfish.Silica 1.0
import "components"
import "pages"
import "cover"

ApplicationWindow {
    cover: coverPage;
    initialPage: firstPage;

    property Playground currentPlayground : null;

    Component {
        id: coverPage;

        CoverPage { }
    }
    Component {
        id: firstPage;

        FirstPage { }
    }
}


