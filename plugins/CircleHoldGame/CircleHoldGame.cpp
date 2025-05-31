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
    return "- На экране будет перемещаться круг.\n"
           "- Ваша задача — навести курсор внутрь круга и удерживать его внутри как можно дольше.\n"
           "- Время удержания зависит от выбранной сложности.\n"
           "- Если вы покинете круг — попытка будет считаться неудачной.\n"
           "- Тренировка заканчивается после определённого числа попыток.";
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

// Путь к иконке стрелки "назад"
QUrl CircleHoldGame::iconArrowUrl() const {
    return QUrl("qrc:/assets/leftArrow.png");
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
