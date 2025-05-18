#ifndef REACTIONTRAINER_H
#define REACTIONTRAINER_H


#include "../../core/BaseModule.h"

class ReactionTrainer : public BaseModule
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID ModuleInterface_iid)
    Q_INTERFACES(ModuleInterface)


public:

    explicit ReactionTrainer(QObject* parent = nullptr) : BaseModule(parent) {}

    QString name() const override {
        return QStringLiteral("Тренировка реакции");
    }
    QString description() const override {
        return QStringLiteral("Упражнение на проверку скорости реакции");
    }
    QString manual() const override{
        return QString("");
    }
    QUrl qmlComponentUrl() const override {
        return QUrl("qrc:/ReactionTrainer.qml");
    }
    QString category() const override {
        return QStringLiteral("Реакция");
    }
    QUrl qmlSettingsUrl() const override {
        return QUrl("");
    }
    QUrl iconUrl() const override {
        return QUrl("");
    }
};
#endif // REACTIONTRAINER_H
