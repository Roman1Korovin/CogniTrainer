#include "TypingSpeedGame.h"
#include <QFile>
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDebug>



TypingSpeedGame::TypingSpeedGame(QObject *parent)
    : BaseModule(parent)
{
    QFile file(":/data/sentences.json");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Не удалось открыть sentences.json";
        return;
    }

    QByteArray jsonData = file.readAll();
    QJsonDocument doc = QJsonDocument::fromJson(jsonData);
    if (!doc.isArray()) {
        qWarning() << "sentences.json должен содержать JSON-массив";
        return;
    }

    QJsonArray arr = doc.array();
    for (const QJsonValue &val : arr) {
        if (val.isString()) {
            m_sentences.append(val.toString());
        }
    }
    emit sentencesChanged();
}

QString TypingSpeedGame::name() const
{
    return "Быстрое письмо";
}

QString TypingSpeedGame::description() const
{
    return "Вводи появляющийся текст как можно быстрее. "
           "Программа измерит твою скорость в символах в минуту.";
}

QString TypingSpeedGame::manual() const
{
    return "- Внимательно смотри на текст, который появляется.\n"
           "- Старайся напечатать его без ошибок и как можно быстрее.\n"
           "- Правильно введенный текст станет - зеленым, неправильно - красным.\n"
           "- Если ты ошибся, введи символ повторно. \n"
           "- Тренирока автоматически начинается после ввода первого символа.\n"
           "- Тренировка закончится как только ввесь текст будет введен.";
}

QUrl TypingSpeedGame::qmlComponentUrl() const
{
    return QUrl("qrc:/TypingSpeedGame.qml");
}

QUrl TypingSpeedGame::qmlSettingsUrl() const
{
    return QUrl("qrc:/TypingSpeedGameSettings.qml"); // Настройки отсутствуют
}

QString TypingSpeedGame::category() const
{
    return "Письмо и ввод";
}

QUrl TypingSpeedGame::iconUrl() const
{
    return QUrl("qrc:/assets/TypingSpeedIcon.png");
}

QUrl TypingSpeedGame::iconArrowDarkUrl() const{
    return QUrl("qrc:/assets/leftArrowDark.png");
}

QUrl TypingSpeedGame::iconArrowLightUrl() const{
    return QUrl("qrc:/assets/leftArrowLight.png");
}

QStringList TypingSpeedGame::sentences() const {
    return m_sentences;
}
