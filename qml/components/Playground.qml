import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: playground;
    width: 400;
    height: 400;
    onFirstChanged:  { stateMachine.restart (); }
    onSecondChanged: { stateMachine.restart (); }
    state: "filling";
    states: [
        State { name: "playing";  },
        State { name: "swapping"; },
        State { name: "cleaning"; },
        State { name: "sliding";  },
        State { name: "filling";  }
    ]
    onStateChanged: { console.log ("STATE", state); }

    Rectangle {
        color: "white";
        opacity: 0.05;
        anchors.fill: parent;
    }
    Timer {
        id: stateMachine;
        repeat: false;
        running: true;
        interval: 50;
        onTriggered: {
            if (playground.state === "playing") {
                trySwap ();
            }
            else if (playground.state === "swapping") {
                var firstSlot  = getSlot (first);
                var secondSlot = getSlot (second);
                var firstGem   = getGem  (first);
                var secondGem  = getGem  (second);
                board [first]  = secondGem;
                board [second] = firstGem;
                first  = -1;
                second = -1;
                if (firstGem && secondGem) {
                    componentSwap.createObject (playground, { // swap gems with animation
                                                    "firstSlot"  : firstSlot,
                                                    "secondSlot" : secondSlot,
                                                    "firstGem"   : firstGem,
                                                    "secondGem"  : secondGem,
                                                });
                }
            }
            else if (playground.state === "cleaning") {
                //var listGroups = getValidGroups ();
                var listGroups = groupGems ([].concat (board));
                if (listGroups.length > 0) {
                    console.log ("listGroups=", JSON.stringify(listGroups));
                    for (var idxGroup = 0; idxGroup < listGroups.length; idxGroup++) {
                        var gemsIdxList = listGroups [idxGroup];
                        var gemsFromGroup = [];
                        for (var j = 0; j < gemsIdxList.length; j++) {
                            var gemIdx = gemsIdxList [j];
                            gemsFromGroup.push (getGem (gemIdx));
                            board [gemIdx] = null;
                        }
                        componentDestroy.createObject (playground, { "gemsFromGroup" : gemsFromGroup });
                        score += (gemsIdxList.length * 10); // FIXME : score computation
                    }
                }
                else {
                    playground.state = "filling";
                    restart ();
                }
            }
            else if (playground.state === "sliding") {
                slideDownGems ();
            }
            else if (playground.state === "filling") {
                fillEmptyCells ();
            }
        }
    }

    property int  score   :0;
    property int  first   : -1;
    property int  second  : -1;
    property int  divs    : 8;
    property int  total   : (divs * divs);
    property real padding : 2;
    property var  board   : [];

    property var  lines   : {
        var ret = [];
        for (var col = 0; col < divs; col++) {
            var tmp = []
            for (var row = 0; row < divs; row++) {
                tmp.push (col + row * divs);
            }
            tmp.reverse ();
            ret.push (tmp);
        }
        console.debug ("lines=", JSON.stringify (ret));
        return ret;
    }

    property list<Component> gems : [
        Component { Gem { type: 1; } }, // yellow circle
        Component { Gem { type: 2; } }, // red square
        Component { Gem { type: 3; } }, // white triangle
        Component { Gem { type: 4; } }, // orange star
        Component { Gem { type: 5; } }, // green octogon
        Component { Gem { type: 6; } }, // blue diamond
        Component { Gem { type: 7; } }  // turquoise egg
    ]

    function reset ()  {
        for (var idx = 0; idx < board.length; idx++) {
            var gem = board [idx];
            if (gem) {
                gem.destroy ();
            }
        }
        board = [];
        score = 0;
        playground.state = "filling";
        stateMachine.restart ();
    }
    function removeDuplicates (array) { // pass an Array as param
        var ret = [];
        for (var idx = 0; idx < array.length; idx++) {
            var val = array [idx];
            if (ret.indexOf (val) < 0) {
                ret.push (val);
            }
        }
        return ret;
    }
    function getSlot (idx) {
        return repeater.itemAt (idx);
    }
    function getGem (idx) {
        return (board [idx] || null);
    }
    function getSurroundingIdx (idx) {
        var ret = [];
        if (idx >= divs) { // not on first row
            ret.push (idx - divs); // do have a cell up
        }
        if (idx % divs !== 0) { // not on first column
            ret.push (idx - 1); // do have a cell left
        }
        if (idx + divs < divs * divs) { // not on last row
            ret.push (idx + divs); // do have a cell down
        }
        if ((idx +1) % divs !== 0) { // not on last column
            ret.push (idx +1); // do have a cell right
        }
        return ret;
    }
    function dealSurrounding (tab, index, type) {
        var suround = getSurroundingIdx (index);
        var res = [];
        //console.debug(index, suround, tab);
        for (var i = 0; i < suround.length; i++) {
            var gem = tab [suround [i]];
            if (gem) {
                if (gem.type === type) {
                    tab [suround [i]] = undefined;
                    res.push (suround [i]);
                    res = res.concat (dealSurrounding (tab, suround [i], gem.type));
                }
            }
        }
        return res;
    }
    function groupGems (tab) {
        var res     = []
        var counter = 0;
        for (var i = 0; i < total; i++) {
            var gem = tab [i];
            if (gem) {
                //console.debug("deal with", i, gem, gem.type);
                tab [i] = undefined;
                var group = [i].concat (dealSurrounding (tab, i, gem.type));
                counter += group.length;
                if (group.length >= 3) {
                    console.debug ("index", i, "group", group);
                    res.push (group);
                }
            }
        }
        //console.debug (counter);
        return res;
    }
    function fillEmptyCells () {
        var counter = 0;
        for (var idx = 0; idx < total; idx++) {
            var slot = getSlot (idx);
            var gem  = getGem  (idx);
            if (gem === null) {
                var tmp = Math.round (Math.random () * (gems.length -1));
                var delta = -(slot.y + slot.height);
                var component = gems [tmp];
                gem = component.createObject (slot, { "x" : 0, "y" : delta });
                board [idx] = gem;
                componentMove.createObject (playground, { "gem" : gem, "slot": slot });
                counter++;
            }
        }
        playground.state = (counter > 0 ? "cleaning" : "playing");
        stateMachine.restart ();
    }
    function trySwap () {
        if (first >= 0 && second >= 0) { // test if first and second are selected
            if (first !== second) { // test if same gem
                var tmp = getSurroundingIdx (first);
                console.log ("first=", first, "second=", second, "tmp=", JSON.stringify (tmp));
                if (tmp.indexOf (second) >= 0) { // test if gems are adjacent
                    var tempBoard = [].concat (board);
                    tempBoard [first]  = board [second];
                    tempBoard [second] = board [first];
                    var swapFirstGroup  = dealSurrounding (tempBoard, first,  board [first].type);
                    var swapSecondGroup = dealSurrounding (tempBoard, second, board [second].type);
                    console.debug (swapFirstGroup, swapSecondGroup);
                    if (swapFirstGroup.length >= 3 || swapSecondGroup.length >= 3) {
                        playground.state = "swapping";
                        stateMachine.restart ();
                        return;
                    }
                }
            }
            first  = -1;
            second = -1;
        }
        playground.state = "playing";
    }
    function slideDownGems () {
        for (var lineIdx = 0; lineIdx < lines.length; lineIdx++) {
            var idxList = lines [lineIdx];

            var oldGems = [];
            for (var idxInList = 0; idxInList < idxList.length; idxInList++) {
                var idx = idxList [idxInList];
                var gem = getGem (idx);
                if (gem !== null && gem !== undefined) {
                    oldGems.push (gem);
                    board [idx] = null;
                }
            }

            for (var idxInGems = 0; idxInGems < oldGems.length; idxInGems++) {
                var currGem = oldGems [idxInGems];
                var newIdx  = idxList [idxInGems];
                board [newIdx] = currGem;
                componentMove.createObject (playground, {
                                                "gem"  : currGem,
                                                "slot" : getSlot (newIdx)
                                            });
            }
        }
    }

    Component {
        id: componentDestroy;

        SequentialAnimation {
            id: animDestroy;
            loops: 1;
            running: true;
            alwaysRunToEnd: true;
            onStopped: { destroy (); }

            property list<Gem> gemsFromGroup;

            PropertyAnimation {
                targets: animDestroy.gemsFromGroup;
                properties: "scale,opacity";
                to: 0.0;
                duration: 150;
            }
            ScriptAction {
                script: {
                    for (var idx = animDestroy.gemsFromGroup.length -1; idx > 0; idx--) {
                        animDestroy.gemsFromGroup [idx].destroy ();
                    }
                    playground.state = "sliding";
                    stateMachine.restart ();
                }
            }
        }
    }
    Component {
        id: componentMove;

        SequentialAnimation {
            id: animMove;
            loops: 1;
            running: false;
            alwaysRunToEnd: true;
            onStopped: { destroy (); }
            Component.onCompleted: {
                var pos  = animMove.slot.mapFromItem (gem, gem.x, gem.y);
                gem.parent = animMove.slot;
                gem.x = pos ['x'];
                gem.y = pos ['y'];
                start ();
            }

            property Gem       gem  : null;
            property MouseArea slot : null;

            PropertyAnimation {
                target: animMove.gem;
                properties: "x,y";
                to: 0;
                duration: 150;
            }
            ScriptAction {
                script: {
                    playground.state = "cleaning";
                    stateMachine.restart ();
                }
            }
        }
    }
    Component {
        id: componentSwap;

        SequentialAnimation {
            id: animSwap;
            loops: 1;
            running: false;
            alwaysRunToEnd: true;
            onStopped: { destroy (); }
            Component.onCompleted: {
                var firstPos  = animSwap.secondSlot.mapFromItem (firstGem,  firstGem.x,  firstGem.y);
                var secondPos = animSwap.firstSlot.mapFromItem  (secondGem, secondGem.x, secondGem.y);

                firstGem.parent = animSwap.secondSlot;
                firstGem.x = firstPos ['x'];
                firstGem.y = firstPos ['y'];

                secondGem.parent = animSwap.firstSlot;
                secondGem.x = secondPos ['x'];
                secondGem.y = secondPos ['y'];

                start ();
            }

            property Gem       firstGem   : null;
            property Gem       secondGem  : null;
            property MouseArea firstSlot  : null;
            property MouseArea secondSlot : null;

            PropertyAnimation {
                targets: [animSwap.firstGem, animSwap.secondGem];
                properties: "x,y";
                to: 0;
                duration: 150;
            }
            ScriptAction {
                script: {
                    playground.state = "cleaning";
                    stateMachine.restart ();
                }
            }
        }
    }
    Grid {
        rows: grid.rows;
        columns: grid.columns;
        spacing: grid.spacing;
        anchors.fill: grid;

        Repeater {
            model: repeater.model;
            delegate: Rectangle {
                color: "black";
                width: grid.itemSize;
                height: grid.itemSize;
                radius: (width * 0.05);
                opacity: 0.05;
            }
        }
    }
    Grid {
        id: grid;
        rows: divs;
        columns: divs;
        width: size;
        height: size;
        spacing: padding;
        enabled: (playground.state === "playing");
        anchors.centerIn: parent;

        property real size       : Math.min (parent.width, parent.height) - padding * 2;
        property real itemSize   : ((size + padding) / divs) - padding;

        Repeater {
            id: repeater;
            model: total;
            delegate: MouseArea {
                id: slot;
                width: grid.itemSize;
                height: grid.itemSize;
                onClicked: {
                    var gem = getGem (model.index);
                    if (gem !== null && gem !== undefined) {
                        if (first < 0) {
                            first = model.index;
                        }
                        else if (second < 0) {
                            second = model.index;
                        }
                        else { } // do nothing, because trySwap will do the rest
                    }
                    else { } // don't select cell because there is no gem here
                }

                Rectangle {
                    color: "transparent";
                    radius: (width * 0.05);
                    visible: (slot.pressed || first === model.index || second === model.index);
                    border {
                        width: 2;
                        color: Theme.highlightColor;
                    }
                    anchors.fill: slot;
                }
            }
        }
    }
}
