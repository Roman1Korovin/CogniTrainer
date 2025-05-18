import QtQuick
import QtQuick.Controls


Row {
   id:  root
   width: parent.width
   height: parent.height

   property string selectedCategoryName
   property var selectedTrainingUrl: null


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

           property string selectedCategoryName: ""
           property var selectedTrainingUrl: null

           property var filteredModules: moduleList.filter(function(module) {
               return selectedCategoryName === "" || module.category === selectedCategoryName;
           })

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

           Rectangle {
               width: 2
               height: parent.height
               color: "#cccccc"
           }

           GridView {
               id: trainingGrid
               width: parent.width * 0.75
               height: parent.height
               cellWidth: 260 + 16
               cellHeight: 120 + 16
               topMargin: 30
               leftMargin: 30
               rightMargin: 10
               model: filteredModules
               clip: true

               delegate: TrainingCardItem {
                   name: modelData.name
                   description: modelData.description

                   MouseArea {
                       anchors.fill: parent
                       hoverEnabled: true
                       cursorShape: Qt.PointingHandCursor
                       onClicked: {
                           console.log("Открываю тренировку: " + modelData.qmlSettingsUrl)
                           stackView.push(modelData.qmlSettingsUrl, {
                               moduleData: modelData,
                               stackViewRef: stackView
                           })
                       }
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

