import QtQuick
import QtQuick.Controls
import "../components"

Row {
   id:  root
   width: parent.width
   height: parent.height

   property string selectedCategoryName: ""
   property var selectedTrainingUrl
   property int maxCardHeight: 0

   Component.onCompleted: {
      if (filteredModules.length > 0) {
         selectedCategoryName = categoryManager.categories[0].name
         selectedTrainingUrl = filteredModules[0].qmlComponentUrl;
         console.log("zzz" + selectedCategoryName + selectedTrainingUrl)
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
         ListView {
            width: parent.width * 0.25
            height: parent.height
            model: categoryManager.categories
            spacing: 20
            topMargin: 30
            clip: true

            delegate: CategoryItem {
               name: model.name
               imagePath: model.imagePath
               isSelected: model.name === selectedCategoryName
               onClicked: {
                  selectedCategoryName = name
                  selectedTrainingUrl = null
               }
            }

            ScrollBar.vertical: ScrollBar {
               policy: ScrollBar.OnDemand
               anchors.right: parent.right
            }
         }

         // разделитель
         Rectangle {
            width: 2
            height: parent.height
            color: "#cccccc"
         }

         //список тренировок в правой части
         GridView {
            id: trainingGrid
            width: parent.width * 0.75
            height: parent.height
            cellWidth: 260 + 16
            cellHeight: maxCardHeight > 0 ? maxCardHeight + 16 : 120 + 16
            topMargin: 30
            leftMargin: 30
            rightMargin: 10
            model: filteredModules
            clip: true

            delegate: TrainingCardItem {
               name: modelData.name
               description: modelData.description

               onHeightReported: {
                  if (h > maxCardHeight) {
                     maxCardHeight = h
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
               policy: ScrollBar.OnDemand
               anchors.right: parent.right
               width: 20
            }
         }
      }
   }
}



