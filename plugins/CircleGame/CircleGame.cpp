#include "CircleGame.h"

// Конструктор
CircleGameModule::CircleGameModule(QObject *parent)
    : BaseModule(parent), m_difficulty(5)  // Явный вызов конструктора базового класса
{
}

// Переопределяем метод name
QString CircleGameModule::name() const {
    return "Попади вовремя";
}

// Переопределяем метод description
QString CircleGameModule::description() const {
    return "Успей нажать на появляющиеся круги до их исчезновения. "
           "50 попыток — улучши свою точность и реакцию!";
}

QString CircleGameModule::manual() const {
    return "- На экране будут случайно появляться круги."
           "- Твоя задача — кликнуть по ним как можно быстрее."
           "- Если ты успел — круг станет зелёным, если нет — появится красный круг."
           "- Всего будет 50 кругов. Постарайся набрать как можно больше попаданий!"
           "- Тренировка заканчивается автоматически после 50 попыток.";
}

// Переопределяем метод для ссылки на QML компонент
QUrl CircleGameModule::qmlComponentUrl() const {
    return QUrl("qrc:/CircleGame.qml");
}

QUrl CircleGameModule::qmlSettingsUrl() const {
    return QUrl("qrc:/CircleGameSettings.qml");
}
// Переопределяем метод category
QString CircleGameModule::category() const {
    return "Реакция";
}

// Переопределяем метод для иконки
QUrl CircleGameModule::iconUrl() const {
    return QUrl("qrc:/CircleGameIcon.png");
}



int CircleGameModule::difficulty() const
{
    return m_difficulty;
}

void CircleGameModule::setDifficulty(int value)
{
    if (m_difficulty != value) {
        m_difficulty = value;
        emit difficultyChanged();
    }
}
