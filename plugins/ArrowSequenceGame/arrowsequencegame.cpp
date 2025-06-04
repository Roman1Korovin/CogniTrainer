#include "ArrowSequenceGame.h"

ArrowSequenceGame::ArrowSequenceGame(QObject *parent)
    : BaseModule(parent)
{}

QString ArrowSequenceGame::name() const
{
    return "Последовательность стрелок";
}

QString ArrowSequenceGame::description() const
{
    return "Правильно и быстро введи последовательность стрелок. "
           "Тренирует внимание, память и координацию.";
}

QString ArrowSequenceGame::manual() const
{
    return "- Смотрите на появляющуюся последовательность стрелок.\n"
           "- Введите её с клавиатуры в правильном порядке.\n"
           "- После ввода появится новая последовательность.\n"
           "- Тренировка заканчивается после заданного количества раундов.";
}

QUrl ArrowSequenceGame::qmlComponentUrl() const
{
    return QUrl("qrc:/ArrowSequenceGame.qml");
}

QUrl ArrowSequenceGame::qmlSettingsUrl() const
{
    return QUrl("qrc:/ArrowSequenceGameSettings.qml"); // Можно создать позже
}

QString ArrowSequenceGame::category() const
{
    return "Письмо и ввод";
}

QUrl ArrowSequenceGame::iconUrl() const
{
    return QUrl("qrc:/assets/ArrowSequenceIcon.png");
}

QUrl ArrowSequenceGame::iconArrowDarkUrl() const{
    return QUrl("qrc:/assets/leftArrowDark.png");
}

QUrl ArrowSequenceGame::iconArrowLightUrl() const{
    return QUrl("qrc:/assets/leftArrowLight.png");
}
