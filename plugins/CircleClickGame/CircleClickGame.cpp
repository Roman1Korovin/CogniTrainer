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
           "Улучши свою точность и реакцию!";
}

QString CircleClickGame::manual() const {
    return "- На экране будут появляться круги в случайном месте.\n"
           "- Твоя задача — кликать по ним как можно быстрее.\n"
           "- Время нахождения круга на экране и размер зависят от уровня сложности.\n"
           "- Если ты успел — круг станет зелёным, если нет — появится красный круг.\n"
           "- Всего будет 40 кругов. Постарайся набрать как можно больше попаданий!\n"
           "- В бесконечном режиме тренировка заканчивается по нажатию на кнопку.";
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

QUrl CircleClickGame::iconArrowDarkUrl() const{
    return QUrl("qrc:/assets/leftArrowDark.png");
}

QUrl CircleClickGame::iconArrowLightUrl() const{
    return QUrl("qrc:/assets/leftArrowLight.png");
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
bool CircleClickGame::endlessMode() const
{
    return m_endlessMode;
}
void CircleClickGame::setEndlessMode(bool value)
{
    if (m_endlessMode != value) {
        m_endlessMode = value;
        emit endlessModeChanged();
    }
}
