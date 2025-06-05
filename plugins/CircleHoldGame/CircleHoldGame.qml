import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15
import QtQuick.Window 2.15
import QtQuick.Dialogs 6.2

Item {
    id: root
    property var moduleData
    property var stackViewRef

    // Параметры круга

    property bool cursorInside: false
    property real trainingTime: 30
    property real remainingTime: trainingTime
    property real lastUpdateTime: 0

    property real heldDuration: 0          //время в круге
    property real accuracy: 0              // Точность в процентах
    property real startTime: 0             // Время начала тренировки
    property real elapsedTime: 0           // Прошедшее время

    property bool paused: false

    property int difficultyValue: moduleData ? moduleData.difficulty : 5
    property bool endlessMode: moduleData && moduleData.endlessMode === true

    property real difficultyFactor: {
        switch (difficultyValue) {
        case 1: return 0.25
        case 2: return 0.4
        case 3: return 0.6
        case 4: return 0.8
        case 5: return 1.0
        case 6: return 1.2
        case 7: return 1.4
        case 8: return 1.7
        case 9: return 2.2
        case 10: return 2.7

        default: return 1.0
        }
    }

    property int circleRadius: {
        switch (difficultyValue) {
        case 1: return 250
        case 2: return 200
        case 3: return 160
        case 4: return 120
        case 5: return 100
        case 6: return 80
        case 7: return 70
        case 8: return 70
        case 9: return 70
        case 10: return 70

        default: return 1.0
        }
    }

    Component.onCompleted: {
        countdownTimer.start()
        circle.setRandomPosition()
        circle.setRandomTargetAngle()
    }

    //верхняя панель
        Rectangle {
            id: topBar
            height: 75
            width: parent.width
            anchors.top: parent.top

            color: Material.theme === Material.Dark ? Qt.darker(Material.background, 1.3) : Qt.darker(Material.background, 1.05)

            // Нижняя граница
            Rectangle {
                height: 2
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                color: "grey"
                z: 10
            }


            MouseArea {
                id: backArea
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 10
                width: row.implicitWidth
                height: row.implicitHeight+10
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: stackViewRef.pop()

                Rectangle {
                    anchors.fill: parent
                    color: Material.theme === Material.Dark ?
                               (backArea.pressed ? Qt.darker(Material.background ,1.2) : backArea.containsMouse ? Qt.darker("#32475c",1.1) : "#32475c") :
                               (backArea.pressed ? Qt.darker("white",1.2) : backArea.containsMouse ? Qt.darker("white",1.1) : "white")
                    radius: 8
                    border.color: "grey"
                    border.width: 2
                }

                Row {
                    id: row
                    spacing: 20
                    anchors.fill: parent
                    leftPadding: 10
                    rightPadding: 10
                    Layout.alignment: Qt.AlignVCenter

                    Image {
                        source: Material.theme === Material.Dark ?moduleData.iconArrowLightUrl : moduleData.iconArrowDarkUrl
                        width: 40
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        anchors.verticalCenter: parent.verticalCenter
                    }

                   Label {
                        text: moduleData?.name || ""
                        font.pixelSize: 26
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Row{


                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.top: parent.top
                anchors.topMargin: 20
                spacing: 50

                Label {
                    text: !endlessMode
                          ? "Осталось: " + Math.max(0, (trainingTime - elapsedTime)).toFixed(0) + " сек"
                          : ""
                    font.pixelSize: 26
                }
                Label {
                    text: "Точность: " + accuracy.toFixed(1) + "%"
                    font.pixelSize: 26

                }
            }


            RowLayout{
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                Item {
                    width: 60
                    height: 60
                    visible: endlessMode && !gameOverOverlay.visible && !countdownOverlay.visible


                    MouseArea {
                        id: pauseMouseArea
                        anchors.fill: parent
                        onClicked: root.togglePause()
                        cursorShape: Qt.PointingHandCursor
                    }

                    Rectangle {

                        anchors.fill: parent
                        radius: width / 2
                        color: Material.theme === Material.Dark ?
                                   (pauseMouseArea.pressed ? Qt.darker("#32475c",1.2) : pauseMouseArea.containsMouse ? Qt.darker("#32475c",1.1) : "#32475c") :
                                   (pauseMouseArea.pressed ? Qt.darker("#666",1.2) : pauseMouseArea.containsMouse ? Qt.darker("#666",1.1) : "#666")

                        border.color:  "grey"
                        border.width:  1
                    }

                    // Левая палочка
                    Rectangle {
                        width: 5
                        height: 16
                        radius: 2
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.horizontalCenter
                        anchors.rightMargin: 2
                    }

                    // Правая палочка
                    Rectangle {
                        width: 5
                        height: 16
                        radius: 2
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.horizontalCenter
                        anchors.leftMargin: 2
                    }

                }


                Item {
                    width: 60
                    height: 60
                    visible: endlessMode && !gameOverOverlay.visible && !countdownOverlay.visible

                    MouseArea {
                        id: endMouseArea
                        anchors.fill: parent
                        onClicked: root.endGame()
                        cursorShape: Qt.PointingHandCursor
                    }

                    Rectangle {

                        anchors.fill: parent
                        radius: width / 2
                        color: Material.theme === Material.Dark ?
                                   (endMouseArea.pressed ? Qt.darker("#32475c",1.2) : endMouseArea.containsMouse ? Qt.darker("#32475c",1.1) : "#32475c") :
                                   (endMouseArea.pressed ? Qt.darker("#666",1.2) : endMouseArea.containsMouse ? Qt.darker("#666",1.1) : "#666")
                        border.color:  "grey"
                        border.width:  1
                    }

                    Rectangle {
                        width: 14
                        height: 14
                        color: "white"
                        radius: 3
                        anchors.centerIn: parent
                    }
                }
            }
        }

        //основнйо экран
        Rectangle {
            id: field
            anchors {
                top: topBar.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            color: Material.background
            clip: true



            MouseArea {
                id: tracker
                anchors.fill: parent
                hoverEnabled: true
                onPositionChanged: {
                    const dx = mouse.x - (circle.x + circleRadius)
                    const dy = mouse.y - (circle.y + circleRadius)
                    const dist = Math.sqrt(dx * dx + dy * dy)
                    cursorInside = dist <= circleRadius
                }
            }

            Timer {
                id: cursorCheckTimer
                interval: 30  // Проверка ~30 раз в секунду
                repeat: true
                running: false
                onTriggered: {
                    const dx = tracker.mouseX - (circle.x + circleRadius)
                    const dy = tracker.mouseY - (circle.y + circleRadius)
                    const dist = Math.sqrt(dx * dx + dy * dy)
                    cursorInside = dist <= circleRadius
                }
            }

            Rectangle {
                id: circle
                property int diameter: circleRadius * 2
                width: diameter
                height: diameter
                radius: circleRadius
                color: "#cccccc"
                border.width: 4
                border.color: cursorInside ? "green" : "red"

                property real angle: 0             // текущий угол движения
                property real targetAngle: 0       // целевой угол движения
                property real turnSpeed: 0.005      // скорость поворота (рад/кадр)
                property real speed: 300 * difficultyFactor           // px/sec

                // Следим за изменениями размеров поля, чтобы не выйти за границы
                function clampPosition() {
                    if (x < 0) x = 0
                    if (y < 0) y = 0
                    if (x > field.width - diameter) x = field.width - diameter
                    if (y > field.height - diameter) y = field.height - diameter
                }

                // Корректируем позицию круга при изменении размеров поля
                onXChanged: clampPosition()
                onYChanged: clampPosition()


                function normalizeAngle(a) {
                    while (a < 0) a += 2 * Math.PI;
                    while (a >= 2 * Math.PI) a -= 2 * Math.PI;
                    return a;
                }

                function shortestAngleDiff(from, to) {
                    let diff = to - from;
                    if (diff > Math.PI) diff -= 2 * Math.PI;
                    if (diff < -Math.PI) diff += 2 * Math.PI;
                    return diff;
                }

                function setRandomTargetAngle() {
                    targetAngle = Math.random() * 2 * Math.PI;
                }

                function setRandomPosition() {
                    x = Math.random() * (root.width - diameter)
                    y = Math.random() * (root.height - topBar.height - diameter)
                }

                Timer {
                    id: moveLoop
                    interval: 8
                    running: false
                    repeat: true
                    onTriggered: {
                        // Плавный поворот в сторону targetAngle
                        let diff = circle.shortestAngleDiff(circle.angle, circle.targetAngle);
                        if (Math.abs(diff) < circle.turnSpeed) {
                            circle.angle = circle.targetAngle; // достигли цели
                        } else {
                            circle.angle += diff > 0 ? circle.turnSpeed : -circle.turnSpeed;
                            circle.angle = circle.normalizeAngle(circle.angle);
                        }

                        // Двигаемся по направлению angle
                        let dx = Math.cos(circle.angle) * circle.speed * interval / 1000;
                        let dy = Math.sin(circle.angle) * circle.speed * interval / 1000;

                        let newX = circle.x + dx;
                        let newY = circle.y + dy;

                        if (newX < 0 || newX > root.width - circle.diameter) {
                            circle.angle = Math.PI - circle.angle; // отражаем угол по X
                            circle.angle = circle.normalizeAngle(circle.angle);
                        } else {
                            circle.x = newX;
                        }

                        if (newY < 0 || newY > root.height - topBar.height - circle.diameter) {
                            circle.angle = -circle.angle; // отражаем угол по Y
                            circle.angle = circle.normalizeAngle(circle.angle);
                        } else {
                            circle.y = newY;
                        }
                    }
                }

                Timer {
                    id: directionTimer
                    interval: 3000
                    running: false
                    repeat: true
                    onTriggered: circle.setRandomTargetAngle()
                }

            }

        }

        Rectangle {
            id: gameOverOverlay
            visible: false
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.6)
            z: 1000

            Rectangle {
                width: 800
                height: 300
                radius: 12
                anchors.centerIn: parent
                color: Material.theme === Material.Light ? "white" : "#2c3e50"
                border.color: Material.theme === Material.Light ? "#cccccc" : "#34495e"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 16
                    anchors.margins: 16

                    Label {
                        text: "Тренировка завершена!"
                        font.pixelSize: 26
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    }
                    Item {
                        Layout.fillHeight: true // занимает все свободное пространство, сдвигая остальные элементы
                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        spacing: 8
                        Label {
                            text: "Время в круге: " + heldDuration.toFixed(1) + " сек"
                            font.pixelSize: 20
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        }
                        Label {
                            text: "Процент времени в круге: " + accuracy.toFixed(1)
                            font.pixelSize: 20
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        }
                    }

                    Item {
                        Layout.fillHeight: true // занимает все свободное пространство, сдвигая остальные элементы
                    }

                    Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing:50
                        Button {
                            text: "Сыграть снова"
                            width:300

                            onClicked: {
                                heldDuration = 0
                                accuracy = 0
                                startTime = 0
                                elapsedTime = 0
                                circle.setRandomPosition()
                                circle.setRandomTargetAngle()
                                gameOverOverlay.visible = false
                                countdownTimer.start()
                                countdownOverlay.countdownValue = 3
                                countdownOverlay.visible = true
                            }
                        }
                        Button {
                            text: "Выйти к настройкам"
                            width:300

                            onClicked: {
                                stackViewRef.pop()
                            }
                        }
                    }
                }
            }
        }
    Item {
        id: countdownOverlay
        anchors.fill: parent
        visible: true
        z: 999
        property int countdownValue: 3

        Rectangle {
            width: 200
            height: 200
            radius: width / 2
            color: Qt.rgba(0, 0, 0, 0.6)
            anchors.centerIn: parent

            Text {
                text: countdownOverlay.countdownValue > 0 ? countdownOverlay.countdownValue : "Старт!"
                anchors.centerIn: parent
                font.pixelSize: 50
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Item {
        id: pauseOverlay
        anchors.fill: parent
        visible: false
        z: 998

        Rectangle {
            width: 150
            height: 150
            radius: width / 2
            color: Qt.rgba(0, 0, 0, 0.6)
            anchors.centerIn: parent

            Text {
                text: "Пауза"
                anchors.centerIn: parent
                font.pixelSize: 28
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Синхронизируем состояние паузы при клике на оверлей
                if (root.paused) {
                    root.togglePause();
                }
            }
        }
    }

    Timer {
        id: trainingTimer
        interval: 20
        running: false
        repeat: true
        onTriggered: {
            var now = Date.now()
            var dt = (now - lastUpdateTime) / 1000.0
            lastUpdateTime = now


            if (cursorInside)
                heldDuration += dt

            if(!endlessMode){
                if ((now - startTime) / 1000.0 >= trainingTime) {
                    trainingTimer.stop()
                    moveLoop.stop()
                    directionTimer.stop()
                    cursorCheckTimer.stop()
                    gameOverOverlay.visible = true
                    updateTimer.stop()
                }
            }
        }
    }

    Timer {
        id: countdownTimer
        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            countdownOverlay.countdownValue--;
            if (countdownOverlay.countdownValue < 0) {
                countdownTimer.stop();
                countdownOverlay.visible = false;

                startTime = Date.now()
                lastUpdateTime = startTime

                trainingTimer.start()

                moveLoop.start()
                directionTimer.start()
                cursorCheckTimer.start()
                updateTimer.start()
            }
        }
    }

    Timer {
        id: updateTimer
        interval: 100
        running: false
        repeat: true
        onTriggered: {
            var now = Date.now()
            elapsedTime = (now - startTime) / 1000.0
            if (elapsedTime > 0) {
                accuracy = (heldDuration / elapsedTime) * 100.0
            }
        }
    }

    function endGame() {
        trainingTimer.stop()
        moveLoop.stop()
        directionTimer.stop()
        cursorCheckTimer.stop()
        gameOverOverlay.visible = true
        updateTimer.stop()
    }


    function togglePause() {
        if (paused) {
            trainingTimer.start()
            moveLoop.start()
            directionTimer.start()
            cursorCheckTimer.start()
            updateTimer.start()
            pauseOverlay.visible =false;
        } else {
            trainingTimer.stop()
            moveLoop.stop()
            directionTimer.stop()
            cursorCheckTimer.stop()
            updateTimer.stop()
            pauseOverlay.visible = true;
        }
        paused = !paused;
    }
}



