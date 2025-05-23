#include "CircleHoldGame.h"

// Конструктор
CircleHoldGameModule::CircleHoldGameModule(QObject *parent)
    : BaseModule(parent), m_difficulty(5)  // Начальный уровень сложности
{
}

// Название тренировки
QString CircleHoldGameModule::name() const {
    return "Удержи круг";
}

// Описание для отображения в общем списке
QString CircleHoldGameModule::description() const {
    return "Наведи курсор на круг и удерживай его внутри пока он двигается. "
           "Тренировка на стабильность реакции и точность.";
}

// Подробная инструкция
QString CircleHoldGameModule::manual() const {
    return "- На экране будет перемещаться круг.\n"
           "- Ваша задача — навести курсор внутрь круга и удерживать его внутри как можно дольше.\n"
           "- Время удержания зависит от выбранной сложности.\n"
           "- Если вы покинете круг — попытка будет считаться неудачной.\n"
           "- Тренировка заканчивается после определённого числа попыток.";
}

// Путь к основному QML-компоненту тренировки
QUrl CircleHoldGameModule::qmlComponentUrl() const {
    return QUrl("qrc:/CircleHoldGame.qml");
}

// Путь к QML-настройкам
QUrl CircleHoldGameModule::qmlSettingsUrl() const {
    return QUrl("qrc:/CircleHoldGameSettings.qml");
}

// Категория тренировки
QString CircleHoldGameModule::category() const {
    return "Реакция";
}

// Иконка тренировки
QUrl CircleHoldGameModule::iconUrl() const {
    return QUrl("qrc:/assets/CircleHoldGameIcon.png");
}

// Путь к иконке стрелки "назад"
QUrl CircleHoldGameModule::iconArrowPath() const {
    return QUrl("qrc:/assets/lefttArrow.png");
}

// Геттер сложности
int CircleHoldGameModule::difficulty() const {
    return m_difficulty;
}

// Сеттер сложности
void CircleHoldGameModule::setDifficulty(int value) {
    if (m_difficulty != value) {
        m_difficulty = value;
        emit difficultyChanged();
    }
}
