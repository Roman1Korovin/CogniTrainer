#ifndef REACTIONTRAINER_H
#define REACTIONTRAINER_H

#include <QObject>
#include "../../interfaces/ModuleInterface.h"

class ReactionTrainer : public QObject, public ModuleInterface
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID ModuleInterface_iid)
    Q_INTERFACES(ModuleInterface)


    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString description READ description CONSTANT)
    Q_PROPERTY(QUrl qmlComponentUrl READ qmlComponentUrl CONSTANT)
    Q_PROPERTY(QString category READ category CONSTANT)


public:

    explicit ReactionTrainer(QObject* parent = nullptr) : QObject(parent) {}

    QString name() const override {

        return QStringLiteral("Тренировка реакции");
    }
    QString description() const override {
        return QStringLiteral("Упражнение на проверку скорости реакции");
    }
    QUrl qmlComponentUrl() const override {
        return QUrl("qrc:/ReactionTrainer.qml");
    }
    QString category() const override {
        return QStringLiteral("Реакция");
    }
};
#endif // REACTIONTRAINER_H
