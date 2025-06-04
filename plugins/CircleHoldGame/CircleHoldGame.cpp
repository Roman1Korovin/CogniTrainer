#include "CircleHoldGame.h"

// Конструктор
CircleHoldGame::CircleHoldGame(QObject *parent)
    : BaseModule(parent), m_difficulty(5)  // Начальный уровень сложности
{
}

// Название тренировки
QString CircleHoldGame::name() const {
    return "Удержи круг";
}

// Описание для отображения в общем списке
QString CircleHoldGame::description() const {
    return "Наведи курсор на круг и удерживай его внутри пока он двигается. "
           "Тренировка на стабильность реакции и точность.";
}

// Подробная инструкция
QString CircleHoldGame::manual() const {
    return "- На экране будет перемещаться круг в случайном направлении.\n"
           "- Ваша задача — навести курсор внутрь круга и удерживать его внутри как можно дольше.\n"
           "- Скорость и размер круга зависят от выбранной сложности.\n"
           "- Тренировка заканчивается по истечению 30 секунд.\n"
           "- В бесконечном режиме выход из тренировки осущетсвляется по нажатию на кнопку. ";
}

// Путь к основному QML-компоненту тренировки
QUrl CircleHoldGame::qmlComponentUrl() const {
    return QUrl("qrc:/CircleHoldGame.qml");
}

// Путь к QML-настройкам
QUrl CircleHoldGame::qmlSettingsUrl() const {
    return QUrl("qrc:/CircleHoldGameSettings.qml");
}

// Категория тренировки
QString CircleHoldGame::category() const {
    return "Реакция";
}

// Иконка тренировки
QUrl CircleHoldGame::iconUrl() const {
    return QUrl("qrc:/assets/CircleHoldGameIcon.png");
}

QUrl CircleHoldGame::iconArrowDarkUrl() const{
    return QUrl("qrc:/assets/leftArrowDark.png");
}

QUrl CircleHoldGame::iconArrowLightUrl() const{
    return QUrl("qrc:/assets/leftArrowLight.png");
}
// Геттер сложности
int CircleHoldGame::difficulty() const {
    return m_difficulty;
}

// Сеттер сложности
void CircleHoldGame::setDifficulty(int value) {
    if (m_difficulty != value) {
        m_difficulty = value;
        emit difficultyChanged();
    }
}

bool CircleHoldGame::endlessMode() const
{
    return m_endlessMode;
}
void CircleHoldGame::setEndlessMode(bool value)
{
    if (m_endlessMode != value) {
        m_endlessMode = value;
        emit endlessModeChanged();
    }
}
