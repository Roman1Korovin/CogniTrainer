#include "TrailMakingTest.h"

// Конструктор
TrailMakingTest::TrailMakingTest(QObject *parent)
    : BaseModule(parent), m_age(60)  // Явный вызов конструктора базового класса
{
}

// Переопределяем метод name
QString TrailMakingTest::name() const {
    return "Тест на соединение точек";
}

// Переопределяем метод description
QString TrailMakingTest::description() const {
    return "Соединяй кружки в правильном порядке. "
           "Классический нейропсихологический тест на внимание и когнитивную гибкость.";
}

// Подробная инструкция
QString TrailMakingTest::manual() const {
    return "- На экране будут расположены кружки с числами в случайных местах.\n"
           "- Твоя задача — нажимать на них по порядку, от 1 до 25, как можно быстрее.\n"
           "- После завершения первого раунда начнётся вторая часть теста.\n"
           "- Теперь ты будешь видеть кружки с числами и кружки с буквами.\n"
           "- Нажимай на них в чередующемся порядке: 1, А, 2, Б, 3, В и так далее, до конца.\n"
           "- В поле ниже обязательно укажи свой возраст — это необходимо для корректной оценки.";
}

// Переопределяем метод для ссылки на QML компонент
QUrl TrailMakingTest::qmlComponentUrl() const {
    return QUrl("qrc:/TrailMakingTest.qml");
}

QUrl TrailMakingTest::qmlSettingsUrl() const {
    return QUrl("qrc:/TrailMakingTestSettings.qml");
}
// Переопределяем метод category
QString TrailMakingTest::category() const {
    return "Тест";
}

// Переопределяем метод для иконки
QUrl TrailMakingTest::iconUrl() const {
    return QUrl("qrc:/assets/TrailMakingIcon.png");
}

QUrl TrailMakingTest::iconArrowDarkUrl() const{
    return QUrl("qrc:/assets/leftArrowDark.png");
}

QUrl TrailMakingTest::iconArrowLightUrl() const{
    return QUrl("qrc:/assets/leftArrowLight.png");
}


int TrailMakingTest::age() const
{
    return m_age;
}

void TrailMakingTest::setAge(int value)
{
    if (m_age != value) {
        m_age = value;
        emit ageChanged();
    }
}
