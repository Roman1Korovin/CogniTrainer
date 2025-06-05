#include "FindPairGame.h"

// Конструктор
FindPairGame::FindPairGame(QObject *parent)
    : BaseModule(parent), m_difficulty(1)  // Явный вызов конструктора базового класса
{
}

// Переопределяем метод name
QString FindPairGame::name() const {
    return "Найди пару";
}

// Переопределяем метод description
QString FindPairGame::description() const {
    return "Запоминай расположение карт и находи одинаковые пары. "
           "Развивай память и внимание!";
}

QString FindPairGame::manual() const {
    return "- В начале игры все карты ненадолго откроются — запомни столько, сколько сможешь!\n"
           "- После этого карты закроются, и тебе нужно поочерёдно открывать по две карты.\n"
           "- Если карты совпадают — пара считается найденной и остаётся открытой.\n"
           "- Если не совпадают — они снова перевернутся.\n"
           "- Цель — найти все пары за минимальное количество попыток и времени.\n"
           "- Количество карточек зависит от выбранного уровня сложности.";
}

// Переопределяем метод для ссылки на QML компонент
QUrl FindPairGame::qmlComponentUrl() const {
    return QUrl("qrc:/FindPairGame.qml");
}

QUrl FindPairGame::qmlSettingsUrl() const {
    return QUrl("qrc:/FindPairGameSettings.qml");
}
// Переопределяем метод category
QString FindPairGame::category() const {
    return "Память";
}

// Переопределяем метод для иконки
QUrl FindPairGame::iconUrl() const {
    return QUrl("qrc:/assets/FindPairIcon.png");
}

QUrl FindPairGame::iconArrowDarkUrl() const{
    return QUrl("qrc:/assets/leftArrowDark.png");
}

QUrl FindPairGame::iconArrowLightUrl() const{
    return QUrl("qrc:/assets/leftArrowLight.png");
}


int FindPairGame::difficulty() const
{
    return m_difficulty;
}

void FindPairGame::setDifficulty(int value)
{
    if (m_difficulty != value) {
        m_difficulty = value;
        emit difficultyChanged();
    }
}
