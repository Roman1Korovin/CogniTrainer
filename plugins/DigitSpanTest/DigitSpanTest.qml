import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root

    property bool hidesTabs: true

    property var moduleData
    property var stackViewRef

    property bool showingDigit: false
    property int sequenceLength: 2     // начинаем с 2 чисел
    property var currentSequence: []
    property int showIndex: 0
    property bool isShowingSequence: false
    property var showTimer: null
    property bool showResult: false
    property bool lastResultSuccess: false

    property int errorsCount: 0          // Счётчик ошибок
    property int maxErrors: 2             // Допустимо 2 ошибки (3-я завершает игру)

    property bool reverseMode: false    // Флаг обратного режима

    property int maxStraightLength: 1   // Максимальная длина прямой последовательности
    property int maxReverseLength: 1    // Максимальная длина обратной последовательности
    property var maxStraightSequence: []
    property var maxReverseSequence: []

    // Свойства для показа инструкции / предупреждения
    property bool showingIntro: false
    property string introText: ""

    // Добавляем флаги, чтобы показывать предупреждение для каждого режима только один раз
    property bool introShownForStraight: false
    property bool introShownForReverse: false

    signal testCompleted(bool success)
    signal gameOver()


    // Верхняя панель
    Rectangle {
        id: topBar
        height: 75
        color: Material.theme === Material.Dark ? Qt.darker(Material.background, 1.3) : Qt.darker(Material.background, 1.05)
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right


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
            anchors.topMargin: 15
            width: row.implicitWidth
            height: row.implicitHeight+10
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: stackViewRef.pop()


            Rectangle {

                anchors.fill: parent
                color: Material.theme === Material.Dark ?
                           (backArea.pressed ? Qt.darker("#32475c" ,1.2) : backArea.containsMouse ? Qt.darker("#32475c",1.1) : "#32475c") :
                           (backArea.pressed ? Qt.darker("white",1.2) : backArea.containsMouse ? Qt.darker("white",1.1) : "white")

                radius: 8
                border.color:  "grey"
                border.width: 2

            }

            Row {
                id: row
                spacing: 20
                anchors.fill: parent
                leftPadding: 10
                rightPadding: 10

                // Выравниваем содержимое по вертикальному центру:
                Layout.alignment: Qt.AlignVCenter


                Image {
                    source: Material.theme === Material.Dark ?moduleData.iconArrowLightUrl : moduleData.iconArrowDarkUrl
                    width: 40
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Label {
                    text: moduleData && moduleData.name ? moduleData.name : ""
                    font.pixelSize: 26
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

        }

        Label {
            id: errorCounterLabel
            text:"Можно допустить ещё " + (maxErrors - errorsCount) + " " + pluralForm(maxErrors - errorsCount, "ошибку", "ошибки", "ошибок")
            font.pixelSize: 30
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: topBar.verticalCenter
            anchors.verticalCenterOffset: -5
            visible: !showingIntro && errorsCount <= maxErrors
        }
    }

    Rectangle {
        id: introOverlay
        visible: showingIntro
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.8)
        z: 10

        Rectangle {
            id: introBox
            width: 800
            height: 300
            radius: 12
            anchors.centerIn: parent
            color: Material.theme === Material.Light ? "white" : "#2c3e50"
            border.color: Material.theme === Material.Light ? "#cccccc" : "#34495e"
            border.width: 1
            opacity: 0.95


            ColumnLayout {
                anchors.fill: parent
                spacing: 16
                anchors.margins: 16

                Label {
                    text: "Внимание!"
                    font.pixelSize: 26
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                }

                Item {
                    Layout.fillHeight: true // занимает все свободное пространство, сдвигая остальные элементы
                }

                Label {
                    text: introText
                    font.pixelSize: 20
                    width: parent.width
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
                }

                Item {
                    Layout.fillHeight: true // занимает все свободное пространство, сдвигая остальные элементы
                }

                Button {
                    text: "Продолжить"
                    Layout.preferredWidth: 400
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        showingIntro = false
                        startNextRound()
                    }
                }
            }
        }
    }


    Label {
        id: modeWarningLabel

        visible: !showingIntro && modeWarningLabel.visible
        font.pixelSize: 26
        color: "orange"

        text: "Теперь вводите последовательность наоборот"

    }

    Label {
        id: digitDisplay
        visible: !showingIntro && !showResult
        font.pixelSize: 40

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -180
    }


    Label {
        id: resultLabelMain
        visible: !showingIntro && showResult
        font.pixelSize: 36
        color: lastResultSuccess ? "green" : "red"
        text: lastResultSuccess ? "Правильно!" : "Ошибка!"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -220

    }


    Label {
        id: resultLabelSequence
        visible: !showingIntro && showResult && !lastResultSuccess
        font.pixelSize: 36
        color: "red"
        text: "Правильная последовательность: " +
              (reverseMode ? currentSequence.slice().reverse().join("") : currentSequence.join(""))
        wrapMode: Text.Wrap

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -180

    }


    ColumnLayout {
        id: mainContent
        anchors.centerIn: parent
        anchors.verticalCenterOffset: +90

        spacing: 10
        width: parent.widt



        TextField {
            id: inputField
            visible: !showingIntro && errorsCount <= maxErrors
            font.pixelSize: 24
            color: "black"
            placeholderText: ""
            text: ""

            inputMethodHints: Qt.ImhDigitsOnly

            focus: true
            Layout.preferredWidth: 400
            Layout.alignment: Qt.AlignHCenter

            horizontalAlignment: Text.AlignHCenter  // Центрируем текст по горизонтали

            background: Rectangle {
                anchors.fill: parent
                color: "white"
                radius: 5
                border.color: "#aaa"
                border.width: 1
            }

            onTextChanged: {
                // удаляем все символы, кроме цифр
                const onlyDigits = text.replace(/\D/g, "")  // \D — всё, кроме цифр
                if (text !== onlyDigits)
                    text = onlyDigits

                // обрезаем по длине текущей последовательности
                if (text.length > currentSequence.length)
                    text = text.slice(0, currentSequence.length)

                inputCounter.text = text.length + "/" + currentSequence.length
                submitButton.enabled = (text.length === currentSequence.length) && !isShowingSequence && errorsCount <= maxErrors
            }
        }

        Label {
            id: inputCounter
            text: "0/" + sequenceLength
            font.pixelSize: 20
            color: "#555"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            visible: !showingIntro && errorsCount <= maxErrors
        }




        GridLayout {
            id: keypad
            columns: 3
            visible: !showingIntro && errorsCount <= maxErrors
            enabled: !isShowingSequence && errorsCount <= maxErrors
            Layout.alignment: Qt.AlignHCenter
            columnSpacing: 10
            rowSpacing: 10
            width: parent.width * 0.7


            Repeater {
                model: 9
                delegate: Button {
                    text: index + 1
                    font.pixelSize: 30
                    Layout.preferredWidth: 130
                    Layout.preferredHeight: 60
                    enabled: keypad.enabled
                    onClicked: {
                        if (inputField.text.length < currentSequence.length) {
                            inputField.text += text
                        }
                        inputField.forceActiveFocus()
                    }
                }
            }


            Button {
                text: "0"
                font.pixelSize: 30
                Layout.preferredWidth: 130
                Layout.preferredHeight: 60
                Layout.row: 3
                Layout.column: 1
                enabled: keypad.enabled
                onClicked: {
                    if (inputField.text.length < currentSequence.length) {
                        inputField.text += text
                    }
                    inputField.forceActiveFocus()
                }
            }

            Button {
                text: "⌫"
                font.pixelSize: 30
                Layout.preferredWidth: 130
                Layout.preferredHeight: 60
                Layout.row: 3
                Layout.column: 2
                enabled: keypad.enabled && inputField.text.length > 0
                onClicked: {
                    inputField.text = inputField.text.slice(0, -1)
                    inputField.forceActiveFocus()
                }
            }
        }

        Button {
            id: submitButton
            text: "Проверить"
            visible: !showingIntro && errorsCount <= maxErrors
            Layout.preferredWidth: 300
            enabled: false
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                const entered = inputField.text
                const correct = reverseMode ? currentSequence.slice().reverse().join("") : currentSequence.join("")
                lastResultSuccess = (entered === correct)
                showResult = true
                if (lastResultSuccess) {
                    // Обновляем максимум для текущего режима
                    if (!reverseMode) {
                        if (sequenceLength > maxStraightLength) {
                            maxStraightLength = sequenceLength
                            maxStraightSequence = currentSequence.slice()
                        }
                    } else {
                        if (sequenceLength > maxReverseLength) {
                            maxReverseLength = sequenceLength
                            maxReverseSequence = currentSequence.slice()
                        }
                    }
                    sequenceLength++
                } else {
                    errorsCount++
                    errorCounterLabel.text = "Можно допустить ещё " + (maxErrors - errorsCount) + " " + pluralForm(maxErrors - errorsCount, "ошибку", "ошибки", "ошибок")
                }

                testCompleted(lastResultSuccess)
                // Отключаем ввод и кнопку, но не меняем видимость — она управляется декларативно
                submitButton.enabled = false
                keypad.enabled = false
                inputField.enabled = false

                if (errorsCount > maxErrors) {
                    if (!reverseMode) {
                        // Переходим в обратный режим с предупреждением, если не показывали
                        reverseMode = true
                        errorsCount = 0
                        errorCounterLabel.text = "Можно допустить ещё " + (maxErrors - errorsCount) + " " + pluralForm(maxErrors - errorsCount, "ошибку", "ошибки", "ошибок")
                        sequenceLength = 2
                        showResult = false
                        inputField.text = ""
                        modeWarningLabel.visible = true
                        if (!introShownForReverse) {
                            introText = "Теперь вводите последовательность наоборот.\nБудьте внимательны!"
                            showingIntro = true
                            introShownForReverse = true
                            modeWarningLabel.visible = false
                        } else {
                            // Если предупреждение уже было — сразу показываем последовательность
                            modeWarningLabel.visible = true
                            Qt.createQmlObject(`
                                import QtQuick 2.0
                                Timer {
                                    interval: 3000
                                    running: true
                                    repeat: false
                                    onTriggered: {
                                        modeWarningLabel.visible = false
                                        root.startShowSequence()
                                    }
                                }
                            `, root, "ModeWarningTimer")
                        }

                        return
                    } else {
                        errorCounterLabel.visible = false
                        showResult = false
                        finalOverlay.visible = true
                        gameOver()
                        return
                    }
                }

                // Через 2 секунды начинаем следующий раунд
                Qt.createQmlObject(`
                    import QtQuick 2.0
                    Timer {
                        interval: 3000
                        running: true
                        repeat: false
                        onTriggered: {
                            showResult = false
                            root.startNextRound()
                        }
                    }
                `, root, "ResultTimer")
            }
        }
    }

    Rectangle {
        id: finalOverlay
        visible: !showingIntro && errorsCount > maxErrors && reverseMode
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.6)
        z: 10

        Rectangle {
            id: finalBox
            width: 1000
            height: 300

            radius: 12

            anchors.centerIn: parent
            color: Material.theme === Material.Light ? "white" : "#2c3e50"
            border.color: Material.theme === Material.Light ? "#cccccc" : "#34495e"
            border.width: 1

            ColumnLayout {
                id: columnFinal
                anchors.fill: parent
                spacing: 16
                anchors.margins: 16

                Label {
                    text: "Тест завершён!"
                    font.bold: true
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
                        text: "Максимальная длина прямой последовательности: " + maxStraightLength + "\n" +
                        "Максимальная длина обратной последовательности: " + maxReverseLength
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.pixelSize: 20
                    }

                    Label {
                        text: interpretDigitSpanCombined(moduleData.age, maxStraightLength, maxReverseLength)
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.pixelSize: 20
                    }
                }


                Item {
                    Layout.fillHeight: true // занимает все свободное пространство, сдвигая остальные элементы
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing:50

                    Button {
                        text: "Выйти к настройкам"
                        width:400

                        onClicked: {
                            stackViewRef.pop()
                        }
                    }
                }
            }
        }
    }

    function pluralForm(n, form1, form2, form5) {
        if (n % 10 === 1 && n % 100 !== 11)
            return form1
        else if ([2,3,4].includes(n % 10) && ![12,13,14].includes(n % 100))
            return form2
        else
            return form5
    }


    function generateSequence(len) {
        let result = []
        for (let i = 0; i < len; i++) {
            result.push(Math.floor(Math.random() * 10))
        }
        return result
    }

    function showNext() {
        if (showIndex >= currentSequence.length && !showingDigit) {
            digitDisplay.text = ""
            isShowingSequence = false

            inputField.enabled = errorsCount <= maxErrors
            keypad.enabled = errorsCount <= maxErrors
            submitButton.visible = errorsCount <= maxErrors
            submitButton.enabled = (inputField.text.length === currentSequence.length) && errorsCount <= maxErrors
            inputCounter.visible = errorsCount <= maxErrors
            inputCounter.text = inputField.text.length + "/" + currentSequence.length
            errorCounterLabel.visible = errorsCount <= maxErrors
            errorCounterLabel.text = "Можно допустить ещё " + (maxErrors - errorsCount) + " " + pluralForm(maxErrors - errorsCount, "ошибку", "ошибки", "ошибок")
            inputField.focus = true

            return
        }

        if (showTimer) {
            showTimer.stop()
            showTimer.destroy()
            showTimer = null
        }

        if (!showingDigit) {
            digitDisplay.text = ""
            showingDigit = true
            showTimer = Qt.createQmlObject(`
                import QtQuick 2.0
                Timer {
                    interval: 500
                    running: true
                    repeat: false
                    onTriggered: root.showNext()
                }
            `, root, "PauseTimer")

        } else {
            digitDisplay.text = currentSequence[showIndex]
            showIndex++
            showingDigit = false
            showTimer = Qt.createQmlObject(`
                import QtQuick 2.0
                Timer {
                    interval: 1000
                    running: true
                    repeat: false
                    onTriggered: root.showNext()
                }
            `, root, "DigitTimer")
        }

        isShowingSequence = true

        inputField.enabled = false
        keypad.enabled = false
        submitButton.enabled = false
    }

    function startNextRound() {
        showResult = false
        inputField.text = ""
        submitButton.enabled = false
        keypad.enabled = false
        currentSequence = generateSequence(sequenceLength)

        // Показываем introOverlay ТОЛЬКО если для этого режима предупреждение еще не показывали
        if (!reverseMode) {
            if (!introShownForStraight) {
                introText = "Сейчас будет показана последовательность чисел.\nВоспроизведи её в том же порядке."
                showingIntro = true
                introShownForStraight = true
                return
            }
        } else {
            if (!introShownForReverse) {
                introText = "Теперь вводи последовательность в обратном порядке.\nБудь внимателен!"
                showingIntro = true
                introShownForReverse = true
                return
            }
        }

        showSequence(currentSequence)
    }

    function startShowSequence() {
        showSequence(currentSequence)
    }

    function showSequence(seq) {
        digitDisplay.visible = true
        showIndex = 0
        currentSequence = seq
        inputField.text = ""
        inputCounter.text = "0/" + currentSequence.length
        inputCounter.visible = true
        errorCounterLabel.visible = true
        submitButton.enabled = false
        showNext()
    }

    function getNormRange(age, isBackward) {
        if (isBackward) {
            if (age <= 5) return [0, 0];
            else if (age <= 7) return [2, 3];
            else if (age <= 9) return [3, 4];
            else if (age <= 12) return [4, 5];
            else if (age <= 17) return [5, 6];
            else if (age <= 29) return [5, 7];
            else if (age <= 39) return [5, 6];
            else if (age <= 49) return [4, 6];
            else if (age <= 59) return [4, 5];
            else if (age <= 69) return [3, 5];
            else return [3, 4];
        } else {
            if (age <= 5) return [3, 4];
            else if (age <= 7) return [4, 5];
            else if (age <= 9) return [5, 6];
            else if (age <= 12) return [6, 7];
            else if (age <= 17) return [7, 8];
            else if (age <= 29) return [7, 9];
            else if (age <= 39) return [6, 8];
            else if (age <= 49) return [6, 7];
            else if (age <= 59) return [5, 7];
            else if (age <= 69) return [5, 6];
            else return [4, 6];
        }
    }

    function interpretSingle(score, range) {
        if (score < range[0])
            return { result: "Ниже возрастной нормы", level: -1 };
        else if (score > range[1])
            return { result: "Выше возрастной нормы", level: 1 };
        else
            return { result: "В пределах нормы", level: 0 };
    }

    function interpretDigitSpanCombined(age, forwardScore, backwardScore) {
        const forwardNorm = getNormRange(age, false);
        const backwardNorm = getNormRange(age, true);

        const forwardInterp = interpretSingle(forwardScore, forwardNorm);
        const backwardInterp = interpretSingle(backwardScore, backwardNorm);

        let summary = "";
        const f = forwardInterp.level;
        const b = backwardInterp.level;

        if (f === -1 && b === -1) {
            summary = "\t\tОба результата ниже возрастной нормы.\n Возможны выраженные трудности с кратковременной и рабочей памятью.";
        } else if (f === 1 && b === 1) {
            summary = "\t\tОба результата выше нормы.\n Отличная память и способности к переработке информации.";
        } else if (f === 0 && b === 0) {
            summary = "\t\tОба результата соответствуют возрастной норме.";
        } else if (f === -1 && b >= 0) {
            summary = "\t\tПрямой ряд ниже нормы, обратный — в пределах нормы.\n Возможны трудности с кратковременным удержанием информации.";
        } else if (f >= 0 && b === -1) {
            summary = "\t\tОбратный ряд ниже нормы, прямой — в пределах нормы.\n Возможны трудности с рабочей памятью и переработкой информации.";
        } else if (f === 1 && b === 0) {
            summary = "\t\tПрямой ряд выше нормы, обратный — в норме.\n Хорошее удержание информации.";
        } else if (f === 0 && b === 1) {
            summary = "\t\tОбратный ряд выше нормы, прямой — в норме.\n Отличные способности к переработке и манипуляции информацией.";
        } else if (f === -1 && b === 1) {
            summary = "\t\tПрямой ряд ниже нормы, обратный — выше.\n Возможен дисбаланс между кратковременной и рабочей памятью.";
        } else if (f === 1 && b === -1) {
            summary = "\t\tПрямой ряд выше нормы, обратный — ниже.\n Хорошее запоминание, но сниженная способность к манипуляции информацией.";
        } else {
            summary = "Нестандартная комбинация результатов.\n Требуется дополнительная интерпретация.";
        }

        return  summary
    }

    Component.onCompleted: {
        startNextRound()
    }
}
