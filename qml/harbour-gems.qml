import QtQuick 2.0;
import Sailfish.Silica 1.0;
import "pages";
import "cover";

ApplicationWindow {
    cover: coverPage;
    initialPage: firstPage;

    Component {
        id: coverPage;

        CoverPage { }
    }
    Component {
        id: firstPage;

        FirstPage { }
    }
    Component {
        id: secondPage;

        SecondPage { }
    }
}


