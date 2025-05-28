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
    return "Тренировка скорости письма";
}

QString TypingSpeedGame::description() const
{
    return "Вводите появляющийся текст как можно быстрее. "
           "Программа измерит вашу скорость в символах в минуту.";
}

QString TypingSpeedGame::manual() const
{
    return "- Внимательно смотрите на текст, который появляется.\n"
           "- Старайтесь напечатать его без ошибок и как можно быстрее.\n"
           "- В конце вы увидите свою скорость и точность.\n";
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
    return QUrl("qrc:/assets/con.png");
}

QUrl TypingSpeedGame::iconArrowPath() const
{
    return QUrl("qrc:/assets/lefttArrow.png");
}

QStringList TypingSpeedGame::sentences() const {
    return m_sentences;
}
