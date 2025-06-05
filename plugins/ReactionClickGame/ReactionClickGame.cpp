#include "ReactionClickGame.h"

// Конструктор
ReactionClickGame::ReactionClickGame(QObject *parent)
    : BaseModule(parent)  // Явный вызов конструктора базового класса
{
}

// Переопределяем метод name
QString ReactionClickGame::name() const {
    return "Моментальная рекция";
}

// Переопределяем метод description
QString ReactionClickGame::description() const {
    return "Следи за кругом и нажимай на него, как только он станет зелёным. "
           "Проверь и прокачай свою реакцию!";
}


QString ReactionClickGame::manual() const {
    return "- На экране будет отображаться красный круг.\n"
           "- Как только круг сменит цвет на зелёный — нажми на экран как можно быстрее.\n"
           "- При раннем нажатии время до появления зеленого круга сбрасывается.\n"
           "- Всего нужно отреагировать на 10 зеленых кругов.\n"
           "- В бесконечном режиме тренировка длится, пока ты сам не остановишь её.\n"
           "- Постарайся минимизировать свою задержку реакции!" ;
}

// Переопределяем метод для ссылки на QML компонент
QUrl ReactionClickGame::qmlComponentUrl() const {
    return QUrl("qrc:/ReactionClickGame.qml");
}

QUrl ReactionClickGame::qmlSettingsUrl() const {
    return QUrl("qrc:/ReactionClickGameSettings.qml");
}
// Переопределяем метод category
QString ReactionClickGame::category() const {
    return "Реакция";
}

// Переопределяем метод для иконки
QUrl ReactionClickGame::iconUrl() const {
    return QUrl("qrc:/assets/ReactionClickIcon.png");
}

QUrl ReactionClickGame::iconArrowDarkUrl() const{
    return QUrl("qrc:/assets/leftArrowDark.png");
}

QUrl ReactionClickGame::iconArrowLightUrl() const{
    return QUrl("qrc:/assets/leftArrowLight.png");
}


bool ReactionClickGame::endlessMode() const
{
    return m_endlessMode;
}

void ReactionClickGame::setEndlessMode(bool value)
{
    if (m_endlessMode != value) {
        m_endlessMode = value;
        emit endlessModeChanged();
    }
}
