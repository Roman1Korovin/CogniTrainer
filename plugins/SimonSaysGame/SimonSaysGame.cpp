#include "SimonSaysGame.h"

// Конструктор
SimonSaysGame::SimonSaysGame(QObject *parent)
    : BaseModule(parent)  // Явный вызов конструктора базового класса
{
}

// Переопределяем метод name
QString SimonSaysGame::name() const {
    return "Саймон говорит";
}

// Переопределяем метод description
QString SimonSaysGame::description() const {
    return "Повторяй за цветами в правильном порядке. "
           "Улучши свою память и концентрацию!";
}

QString SimonSaysGame::manual() const {
    return "- На экране появятся 4 квадрата разных цветов.\n"
           "- В начале игры один из них мигнёт — запомни его.\n"
           "- Затем тебе нужно повторить увиденную последовательность, нажимая на квадраты в правильном порядке.\n"
           "- После каждого успешного раунда последовательность увеличивается на один элемент.\n"
           "- Каждый новый элемент добавляется в конец предыдущей последовательности.\n"
           "- Игра продолжается до первой ошибки — постарайся запомнить как можно больше!\n";
}

// Переопределяем метод для ссылки на QML компонент
QUrl SimonSaysGame::qmlComponentUrl() const {
    return QUrl("qrc:/SimonSaysGame.qml");
}

QUrl SimonSaysGame::qmlSettingsUrl() const {
    return QUrl("qrc:/SimonSaysGameSettings.qml");
}
// Переопределяем метод category
QString SimonSaysGame::category() const {
    return "Память";
}

// Переопределяем метод для иконки
QUrl SimonSaysGame::iconUrl() const {
    return QUrl("qrc:/assets/SimonSaysIcon.png");
}

QUrl SimonSaysGame::iconArrowDarkUrl() const{
    return QUrl("qrc:/assets/leftArrowDark.png");
}

QUrl SimonSaysGame::iconArrowLightUrl() const{
    return QUrl("qrc:/assets/leftArrowLight.png");
}
