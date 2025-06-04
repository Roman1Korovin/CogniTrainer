#ifndef REACTIONCLICKGAME_H
#define REACTIONCLICKGAME_H

#include "../../core/BaseModule.h"


class ReactionClickGame : public BaseModule
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID ModuleInterface_iid)
    Q_INTERFACES(ModuleInterface)

    Q_PROPERTY(bool endlessMode READ endlessMode WRITE setEndlessMode NOTIFY endlessModeChanged)
    Q_PROPERTY(QUrl iconArrowDarkUrl READ iconArrowDarkUrl CONSTANT)
    Q_PROPERTY(QUrl iconArrowLightUrl READ iconArrowLightUrl CONSTANT)

public:

    explicit ReactionClickGame(QObject *parent = nullptr);

    QString name() const override;
    QString description() const override;
    QString manual() const override;
    QUrl qmlComponentUrl() const override;
    QUrl qmlSettingsUrl() const override;
    QString category() const override;
    QUrl iconUrl() const override;
    QUrl iconArrowDarkUrl() const;
    QUrl iconArrowLightUrl() const;


    Q_INVOKABLE bool endlessMode() const;

public slots:
    void setEndlessMode(bool value);

signals:
    void endlessModeChanged();

private:
    bool m_endlessMode;
};

#endif
