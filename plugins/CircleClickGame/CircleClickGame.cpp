#include "CircleClickGame.h"

// Конструктор
CircleClickGame::CircleClickGame(QObject *parent)
    : BaseModule(parent), m_difficulty(5)  // Явный вызов конструктора базового класса
{
}

// Переопределяем метод name
QString CircleClickGame::name() const {
    return "Попади вовремя";
}

// Переопределяем метод description
QString CircleClickGame::description() const {
    return "Успей нажать на появляющиеся круги до их исчезновения. "
           "50 попыток — улучши свою точность и реакцию!";
}

QString CircleClickGame::manual() const {
    return "- На экране будут случайно появляться круги.\n"
           "- Твоя задача — кликнуть по ним как можно быстрее.\n"
           "- Если ты успел — круг станет зелёным, если нет — появится красный круг.\n"
           "- Всего будет 50 кругов. Постарайся набрать как можно больше попаданий!\n"
           "- Тренировка заканчивается автоматически после 50 попыток.\n";
}

// Переопределяем метод для ссылки на QML компонент
QUrl CircleClickGame::qmlComponentUrl() const {
    return QUrl("qrc:/CircleClickGame.qml");
}

QUrl CircleClickGame::qmlSettingsUrl() const {
    return QUrl("qrc:/CircleClickGameSettings.qml");
}
// Переопределяем метод category
QString CircleClickGame::category() const {
    return "Реакция";
}

// Переопределяем метод для иконки
QUrl CircleClickGame::iconUrl() const {
    return QUrl("qrc:/assets/CircleClickGameIcon.png");
}

QUrl CircleClickGame::iconArrowPath() const{
    return QUrl("qrc:/assets/lefttArrow.png");
}

int CircleClickGame::difficulty() const
{
    return m_difficulty;
}

void CircleClickGame::setDifficulty(int value)
{
    if (m_difficulty != value) {
        m_difficulty = value;
        emit difficultyChanged();
    }
}
