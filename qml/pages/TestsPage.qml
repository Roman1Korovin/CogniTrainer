import QtQuick
import QtQuick.Controls
import "../components"

Rectangle {
   id:  root
   width: parent.width
   height: parent.height+10
   y:-10


   color: Material.background


   property var filteredModules: moduleList.filter(function(module) {
           return module.category === "Тест";
       })

   StackView {

      id: stackView
      anchors.fill: parent
      initialItem: moduleSelectionPage
   }


   Component {
           id: moduleSelectionPage

           // Только список тестов без категорий
           Flickable {
               width: parent.width
               height: parent.height
               contentWidth: parent.width
               contentHeight: trainingGrid.contentHeight
               clip: true

               GridView {
                   id: trainingGrid
                   width: parent.width
                   height: parent.height
                   cellWidth: visualImpairment ? (350+30) * 1.3: (350+30)
                   cellHeight: visualImpairment ? (525+30) * 1.3: (525+30)
                   topMargin: 40
                   leftMargin: 30
                   rightMargin: 30
                   model: filteredModules


                   delegate: TrainingCardItem {
                       name: modelData.name
                       iconUrl: modelData.iconUrl
                       description: modelData.description

                       onClicked: {
                           console.log("Открываю тренировку: " + modelData.qmlSettingsUrl)
                           stackView.push(modelData.qmlSettingsUrl, {
                               moduleData: modelData,
                               stackViewRef: stackView
                           })
                       }
                   }

                   Rectangle {
                      id: gradientShadow

                      anchors.top: parent.top
                      height: 10
                      width: trainingGrid.width

                      gradient: Material.theme === Material.Light ? lightGradient : darkGradient

                      Gradient {
                         id: lightGradient
                         GradientStop { position: 0.0; color: "#121314" }
                         GradientStop { position: 1.0; color: backgroundColor }
                      }

                      Gradient {
                         id: darkGradient
                         GradientStop { position: 0.0; color: "#121212" }
                         GradientStop { position: 1.0; color: backgroundColor }
                      }
                   }

                   ScrollBar.vertical: ScrollBar {
                      id: vbar


                      policy: trainingGrid.contentHeight > trainingGrid.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff

                      anchors.top: parent.top
                      anchors.right: parent.right
                      anchors.bottom: parent.bottom
                      width: 16

                      contentItem: Rectangle {
                             radius: width / 2    // закругление по пол-ширины — полностью круглые края
                             color: vbar.pressed ? "#3b4451" : "#5c646c"
                             implicitWidth: 12
                             implicitHeight: 100
                         }
                   }
               }
           }
       }
   }

