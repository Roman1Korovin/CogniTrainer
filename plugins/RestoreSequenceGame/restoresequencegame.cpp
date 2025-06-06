#include "RestoreSequenceGame.h"

// Конструктор
RestoreSequenceGame::RestoreSequenceGame(QObject *parent)
    : BaseModule(parent), m_difficulty(1)  // Явный вызов конструктора базового класса
{
}

// Переопределяем метод name
QString RestoreSequenceGame::name() const {
    return "Порядок карточек";
}

// Переопределяем метод description
QString RestoreSequenceGame::description() const {
    return "Запомни порядок карточек со зверьми и воспроизведи его после перемешивания. "
           "Развивай память и внимание!";
}

QString RestoreSequenceGame::manual() const {
    return "- На экране появится несколько карточек с изображениями зверей.\n"
           "- У тебя будет 10 секунд, чтобы запомнить их порядок.\n"
           "- После этого карточки перевернутся и через короткое время откроются заново, но уже в другом случайном порядке.\n"
           "- Твоя задача — в правильной последовательности выбрать карточки, как они были показаны изначально.\n"
           "- Ниже ты можешь выбрать, сколько карточек будет в последовательности — чем больше, тем сложнее.\n"
           "- Тренировка заканчивается при воспроизведении последовательности или ошибке.";
}
// Переопределяем метод для ссылки на QML компонент
QUrl RestoreSequenceGame::qmlComponentUrl() const {
    return QUrl("qrc:/RestoreSequenceGame.qml");
}

QUrl RestoreSequenceGame::qmlSettingsUrl() const {
    return QUrl("qrc:/RestoreSequenceGameSettings.qml");
}
// Переопределяем метод category
QString RestoreSequenceGame::category() const {
    return "Память";
}

// Переопределяем метод для иконки
QUrl RestoreSequenceGame::iconUrl() const {
    return QUrl("qrc:/assets/RestoreSequenceIcon.png");
}

QUrl RestoreSequenceGame::iconArrowDarkUrl() const{
    return QUrl("qrc:/assets/leftArrowDark.png");
}

QUrl RestoreSequenceGame::iconArrowLightUrl() const{
    return QUrl("qrc:/assets/leftArrowLight.png");
}

int RestoreSequenceGame::difficulty() const
{
    return m_difficulty;
}

void RestoreSequenceGame::setDifficulty(int value)
{
    if (m_difficulty != value) {
        m_difficulty = value;
        emit difficultyChanged();
    }
}
