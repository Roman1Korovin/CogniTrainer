#include "DigitSpanTest.h"

// Конструктор
DigitSpanTest::DigitSpanTest(QObject *parent)
    : BaseModule(parent), m_age(18)  // Явный вызов конструктора базового класса
{
}

// Переопределяем метод name
QString DigitSpanTest::name() const {
    return "Цифровой ряд";
}

// Переопределяем метод description
QString DigitSpanTest::description() const {
    return "Повторяй последовательности чисел. "
           "Классический тест на объём кратковременной памяти.";
}

QString DigitSpanTest::manual() const
{
    return "- На экране будет показана последовательность чисел, начиная с 2 цифр.\n"
           "- Твоя задача — воспроизвести её в том же порядке.\n"
           "- При каждом правильном ответе длина последовательности увеличивается на 1.\n"
           "- Разрешено допустить 2 ошибки. После этого начнётся вторая фаза.\n"
           "- Во второй фазе нужно вводить числа в обратном порядке, от последнего к первому.\n"
           "- Там также можно ошибиться дважды, после чего тест завершится.\n"
           "- В поле ниже обязательно укажи свой возраст — он необходим для анализа результатов.";
}

// Переопределяем метод для ссылки на QML компонент
QUrl DigitSpanTest::qmlComponentUrl() const {
    return QUrl("qrc:/DigitSpanTest.qml");
}

QUrl DigitSpanTest::qmlSettingsUrl() const {
    return QUrl("qrc:/DigitSpanTestSettings.qml");
}
// Переопределяем метод category
QString DigitSpanTest::category() const {
    return "Тест";
}

// Переопределяем метод для иконки
QUrl DigitSpanTest::iconUrl() const {
    return QUrl("qrc:/assets/DigitSpanIcon.png");
}

QUrl DigitSpanTest::iconArrowDarkUrl() const{
    return QUrl("qrc:/assets/leftArrowDark.png");
}

QUrl DigitSpanTest::iconArrowLightUrl() const{
    return QUrl("qrc:/assets/leftArrowLight.png");
}


int DigitSpanTest::age() const
{
    return m_age;
}

void DigitSpanTest::setAge(int value)
{
    if (m_age != value) {
        m_age = value;
        emit ageChanged();
    }
}
