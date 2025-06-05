#ifndef SIMONSAYSGAME_H
#define SIMONSAYSGAME_H

#include "../../core/BaseModule.h"

class SimonSaysGame : public BaseModule
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID ModuleInterface_iid)
    Q_INTERFACES(ModuleInterface)

    Q_PROPERTY(QUrl iconArrowDarkUrl READ iconArrowDarkUrl CONSTANT)
    Q_PROPERTY(QUrl iconArrowLightUrl READ iconArrowLightUrl CONSTANT)

public:

    explicit SimonSaysGame(QObject *parent = nullptr);

    QString name() const override;
    QString description() const override;
    QString manual() const override;
    QUrl qmlComponentUrl() const override;
    QUrl qmlSettingsUrl() const override;
    QString category() const override;
    QUrl iconUrl() const override;
    QUrl iconArrowDarkUrl() const;
    QUrl iconArrowLightUrl() const;
};

#endif
