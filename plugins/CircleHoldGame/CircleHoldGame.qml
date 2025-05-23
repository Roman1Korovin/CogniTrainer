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
    property int circleRadius: 60
    property bool cursorInside: false
    property int trainingTime: 30
    property int remainingTime: trainingTime
    property real heldDuration: 0  // <- нужно, иначе будет ошибка при старте


    property int difficultyValue: moduleData ? moduleData.difficulty : 5

    property real difficultyFactor: {
        switch (difficultyValue) {
            case 1: return 0.2
            case 2: return 0.4
            case 3: return 0.6
            case 4: return 0.8
            case 5: return 1.0
            case 6: return 1.2
            case 7: return 1.4
            case 8: return 1.7
            case 9: return 2.3
            case 10: return 3.0

            default: return 1.0
        }
    }

    Component.onCompleted: {
        circle.setRandomPosition()
        circle.setRandomTargetAngle()
        trainingTimer.start()
        moveLoop.start()
        directionTimer.start()
    }

    Rectangle {
        anchors.fill: parent
        color: "#ffffff"


        Timer {
            id: trainingTimer
            interval: 1000
            running: false
            repeat: true
            onTriggered: {
                remainingTime--
                if (cursorInside)
                    heldDuration += 1
                if (remainingTime <= 0) {
                    trainingTimer.stop()
                    moveLoop.stop()
                    directionTimer.stop()
                    gameOverOverlay.visible = true
                }
            }
        }

        Rectangle {
            id: topBar
            height: 65
            color: "#f0f0f0"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            border.color: "#cccccc"

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
                    color: backArea.pressed ? Qt.darker("white", 1.2) : backArea.containsMouse ? Qt.darker("white", 1.1) : "white"
                    radius: 8
                    border.color: "#a0a0a0"
                    border.width: 1
                }

                Row {
                    id: row
                    spacing: 20
                    anchors.fill: parent
                    leftPadding: 10
                    rightPadding: 10
                    Layout.alignment: Qt.AlignVCenter

                    Image {
                        source: moduleData?.iconArrowPath || ""
                        width: 40
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: moduleData?.name || ""
                        font.pixelSize: 26
                        color: "black"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
            Text {
                id: timeText
                text: "Осталось: " + remainingTime + " сек"
                color: "#333"
                font.pixelSize: 22
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.top: parent.top
                anchors.topMargin: 20
            }
        }

        Rectangle {
            id: field
            anchors {
                top: topBar.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            color: "white"
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
                running: true
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
                    running: true
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
                    running: true
                    repeat: true
                    onTriggered: circle.setRandomTargetAngle()
                }

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
            width: parent.width * 0.5
            height: parent.height * 0.35
            radius: 12
            anchors.centerIn: parent
            color: "#ffffff"
            border.color: "#cccccc"
            border.width: 1

            Column {
                anchors.centerIn: parent
                spacing: 16
                width: parent.width

                Text {
                    text: "Тренировка\nзавершена!"
                    font.pixelSize: 26
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Время в круге: " + heldDuration.toFixed(1) + " сек"
                    font.pixelSize: 20
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    text: "Сыграть снова"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        heldDuration = 0
                        remainingTime = trainingTime
                        circle.setRandomPosition()
                        circle.setRandomTargetAngle()
                        gameOverOverlay.visible = false
                        trainingTimer.restart()
                        moveLoop.restart()
                        directionTimer.restart()
                    }
                }
            }
        }
    }
}
