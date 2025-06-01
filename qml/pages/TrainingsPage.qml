import QtQuick
import QtQuick.Controls
import "../components"

Rectangle {
   id:  root
   width: parent.width
   height: parent.height


   color: Material.background


   property string selectedCategoryName: ""
   property var selectedTrainingUrl
   property int maxCardHeight: 0

   Component.onCompleted: {
      if (filteredModules.length > 0) {
         selectedCategoryName = categoryManager.categories[0].name
         selectedTrainingUrl = filteredModules[0].qmlComponentUrl;
      }
   }


   property var filteredModules: moduleList.filter(function(module) {
      return selectedCategoryName === "" || module.category === selectedCategoryName;
   })



   StackView {

      id: stackView
      anchors.fill: parent
      initialItem: moduleSelectionPage
   }

   // Экран выбора модуля
   Component {
      id: moduleSelectionPage

      Row {
         width: parent.width
         height: parent.height


         //Список категорий в левой части
         Frame{

            width: 460
            height: parent.height

            background: Rectangle {
                    color: Material.theme === Material.Dark ? Qt.darker(Material.background, 1.3) : Qt.darker(Material.background, 1.05)
                }

         ListView {

            id: categoryList
            anchors.fill: parent


            model: categoryManager ? categoryManager.categories : []
            spacing: 20
            topMargin: 30
            clip: true

            delegate: CategoryItem {
               name: model.name
               imageUrl: model.imageUrl
               isSelected: model.name === selectedCategoryName
               onClicked: {
                  selectedCategoryName = name
                  selectedTrainingUrl = null
               }
            }

            ScrollBar.vertical: ScrollBar {
               anchors.right: parent.right
               width: 12
            }

         }
         }

         // разделитель
         Frame {
            id: separator
            width: 2
            height: parent.height

         }

         //список тренировок в правой части
         GridView {
            id: trainingGrid
            width: parent.width - categoryList.width - separator.width
            height: parent.height
            cellWidth: 400 + 16
            cellHeight: maxCardHeight > 0 ? maxCardHeight + 16 : 120 + 16
            topMargin: 30
            leftMargin: 30
            rightMargin: 30
            model: filteredModules
            clip: true

            delegate: TrainingCardItem {
               name: modelData.name
               description: modelData.description

               onHeightReported: function(h) {
                  if (h > maxCardHeight) {
                     maxCardHeight = h;
                  }
               }

               sharedMaxHeight: maxCardHeight

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



