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
         anchors.fill: parent


         //Список категорий в левой части
         Rectangle{

            width: 460
            height: parent.height


            color: Material.theme === Material.Dark ? Qt.darker(Material.background, 1.3) : Qt.darker(Material.background, 1.05)




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
            anchors.top: parent.top
            anchors.topMargin: -10
            anchors.bottom: parent.bottom
            z:1

         }



         //список тренировок в правой части
         GridView {
            id: trainingGrid
            width: parent.width - categoryList.width - separator.width
            height: parent.height+10
            y:-10

            cellWidth: 350 + 20
            cellHeight:  525 + 20

            topMargin: 40
            leftMargin: 30
            rightMargin: 30
            model: filteredModules
            clip: true
            z:1



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
                      radius: width / 2
                      color: vbar.pressed ? Qt.darker("#5c646c",1.3) : "#5c646c"
                      implicitWidth: 12
                      implicitHeight: 100
                  }
            }
         }
      }
   }
}



