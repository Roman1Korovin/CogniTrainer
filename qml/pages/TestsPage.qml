import QtQuick
import QtQuick.Controls
import "../components"

Rectangle {
   id:  root
   width: parent.width
   height: parent.height


   color: Material.background


   property var filteredModules: moduleList.filter(function(module) {
           return module.category === "Реакция"; // временно, потом заменить на "Тест"
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
                   cellWidth: 350 + 20
                   cellHeight: 525 + 20
                   topMargin: 30
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

                   ScrollBar.vertical: ScrollBar {
                       anchors.right: parent.right
                       width: 12
                   }
               }
           }
       }
   }

