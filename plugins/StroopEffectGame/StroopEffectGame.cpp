#include "StroopEffectGame.h"

// Конструктор
StroopEffectGame::StroopEffectGame(QObject *parent)
    : BaseModule(parent), m_difficulty(1)  // Явный вызов конструктора базового класса
{
}

// Переопределяем метод name
QString StroopEffectGame::name() const {
    return "Цвет и слово";
}

// Переопределяем метод description
QString StroopEffectGame::description() const {
    return "Выбери цвет, в который окрашено слово, а не тот, что написан. "
           "Проверь свою концентрацию и когнитивный контроль!";
}

QString StroopEffectGame::manual() const {
    return "- В центре экрана появляется слово — название цвета, окрашенное в случайный цвет.\n"
           "- Ниже отображаются кнопки с названиями цветов. Цвет текста на кнопках также случайный.\n"
           "- Твоя задача — нажать на кнопку с названием **того цвета, в который окрашено слово**, а не того, что написано.\n"
           "- Важно не запутаться — эффект вызывает когнитивный конфликт.\n"
           "- От уровня сложности зависит время, отведённое на выбор. На первом уровне времени сколько угодно.\n"
           "- Всего 10 раундов. В бесконечном режиме тренировка длится до нажатия кнопки завершения.";
}


// Переопределяем метод для ссылки на QML компонент
QUrl StroopEffectGame::qmlComponentUrl() const {
    return QUrl("qrc:/StroopEffectGame.qml");
}

QUrl StroopEffectGame::qmlSettingsUrl() const {
    return QUrl("qrc:/StroopEffectGameSettings.qml");
}
// Переопределяем метод category
QString StroopEffectGame::category() const {
    return "Внимание";
}

// Переопределяем метод для иконки
QUrl StroopEffectGame::iconUrl() const {
    return QUrl("qrc:/assets/StroopEffectIcon.png");
}

QUrl StroopEffectGame::iconArrowDarkUrl() const{
    return QUrl("qrc:/assets/leftArrowDark.png");
}

QUrl StroopEffectGame::iconArrowLightUrl() const{
    return QUrl("qrc:/assets/leftArrowLight.png");
}


int StroopEffectGame::difficulty() const
{
    return m_difficulty;
}

void StroopEffectGame::setDifficulty(int value)
{
    if (m_difficulty != value) {
        m_difficulty = value;
        emit difficultyChanged();
    }
}


bool StroopEffectGame::endlessMode() const
{
    return m_endlessMode;
}

void StroopEffectGame::setEndlessMode(bool value)
{
    if (m_endlessMode != value) {
        m_endlessMode = value;
        emit endlessModeChanged();
    }
}
