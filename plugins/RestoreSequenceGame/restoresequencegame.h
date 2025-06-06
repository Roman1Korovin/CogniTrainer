#ifndef RESTORESEQUENCEGAME_H
#define RESTORESEQUENCEGAME_H

#include "../../core/BaseModule.h"

class RestoreSequenceGame : public BaseModule
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID ModuleInterface_iid)
    Q_INTERFACES(ModuleInterface)

    Q_PROPERTY(int difficulty READ difficulty WRITE setDifficulty NOTIFY difficultyChanged)
    Q_PROPERTY(QUrl iconArrowDarkUrl READ iconArrowDarkUrl CONSTANT)
    Q_PROPERTY(QUrl iconArrowLightUrl READ iconArrowLightUrl CONSTANT)

public:

    explicit RestoreSequenceGame(QObject *parent = nullptr);

    QString name() const override;
    QString description() const override;
    QString manual() const override;
    QUrl qmlComponentUrl() const override;
    QUrl qmlSettingsUrl() const override;
    QString category() const override;
    QUrl iconUrl() const override;
    QUrl iconArrowDarkUrl() const;
    QUrl iconArrowLightUrl() const;

    Q_INVOKABLE int difficulty() const;


public slots:
    void setDifficulty(int value);

signals:
    void difficultyChanged();

private:
    int m_difficulty;
};

#endif
