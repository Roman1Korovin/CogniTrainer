#include "CircleClickGame.h"

// Конструктор
CircleClickGameModule::CircleClickGameModule(QObject *parent)
    : BaseModule(parent), m_difficulty(5)  // Явный вызов конструктора базового класса
{
}

// Переопределяем метод name
QString CircleClickGameModule::name() const {
    return "Попади вовремя";
}

// Переопределяем метод description
QString CircleClickGameModule::description() const {
    return "Успей нажать на появляющиеся круги до их исчезновения. "
           "50 попыток — улучши свою точность и реакцию!";
}

QString CircleClickGameModule::manual() const {
    return "- На экране будут случайно появляться круги.\n"
           "- Твоя задача — кликнуть по ним как можно быстрее.\n"
           "- Если ты успел — круг станет зелёным, если нет — появится красный круг.\n"
           "- Всего будет 50 кругов. Постарайся набрать как можно больше попаданий!\n"
           "- Тренировка заканчивается автоматически после 50 попыток.\n";
}

// Переопределяем метод для ссылки на QML компонент
QUrl CircleClickGameModule::qmlComponentUrl() const {
    return QUrl("qrc:/CircleClickGame.qml");
}

QUrl CircleClickGameModule::qmlSettingsUrl() const {
    return QUrl("qrc:/CircleClickGameSettings.qml");
}
// Переопределяем метод category
QString CircleClickGameModule::category() const {
    return "Реакция";
}

// Переопределяем метод для иконки
QUrl CircleClickGameModule::iconUrl() const {
    return QUrl("qrc:/assets/CircleClickGameIcon.png");
}

QUrl CircleClickGameModule::iconArrowPath() const{
    return QUrl("qrc:/assets/lefttArrow.png");
}

int CircleClickGameModule::difficulty() const
{
    return m_difficulty;
}

void CircleClickGameModule::setDifficulty(int value)
{
    if (m_difficulty != value) {
        m_difficulty = value;
        emit difficultyChanged();
    }
}
