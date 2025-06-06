#include "FindAnotherColorGame.h"

// Конструктор
FindAnotherColorGame::FindAnotherColorGame(QObject *parent)
    : BaseModule(parent), m_difficulty(1)  // Явный вызов конструктора базового класса
{
}

// Переопределяем метод name
QString FindAnotherColorGame::name() const {
    return "Найди предмет";
}

// Переопределяем метод description
QString FindAnotherColorGame::description() const {
    return "Найди квадрат, отличающийся по цвету. "
           "Развивай внимательность и зрительное восприятие!";
}

QString FindAnotherColorGame::manual() const {
    return "- На экране появляется поле, заполненное квадратами одного цвета.\n"
           "- Один из квадратов отличается по цвету — совсем немного, будь внимателен!\n"
           "- Твоя задача — как можно быстрее найти и нажать на отличающийся квадрат.\n"
           "- От уровня сложности зависит количество квадратов и время, отведённое на поиск.\n"
           "- На первом уровне таймер отсутствует, можно искать без спешки.\n"
           "- Всего предстоит пройти 10 раундов.\n"
           "- В бесконечном режиме тренировка продолжается до нажатия кнопки завершения.";
}

// Переопределяем метод для ссылки на QML компонент
QUrl FindAnotherColorGame::qmlComponentUrl() const {
    return QUrl("qrc:/FindAnotherColorGame.qml");
}

QUrl FindAnotherColorGame::qmlSettingsUrl() const {
    return QUrl("qrc:/FindAnotherColorGameSettings.qml");
}
// Переопределяем метод category
QString FindAnotherColorGame::category() const {
    return "Внимание";
}

// Переопределяем метод для иконки
QUrl FindAnotherColorGame::iconUrl() const {
    return QUrl("qrc:/assets/FindAnotherColorIcon.png");
}

QUrl FindAnotherColorGame::iconArrowDarkUrl() const{
    return QUrl("qrc:/assets/leftArrowDark.png");
}

QUrl FindAnotherColorGame::iconArrowLightUrl() const{
    return QUrl("qrc:/assets/leftArrowLight.png");
}


int FindAnotherColorGame::difficulty() const
{
    return m_difficulty;
}

void FindAnotherColorGame::setDifficulty(int value)
{
    if (m_difficulty != value) {
        m_difficulty = value;
        emit difficultyChanged();
    }
}

bool FindAnotherColorGame::endlessMode() const
{
    return m_endlessMode;
}

void FindAnotherColorGame::setEndlessMode(bool value)
{
    if (m_endlessMode != value) {
        m_endlessMode = value;
        emit endlessModeChanged();
    }
}
