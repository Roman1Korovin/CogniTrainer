#ifndef CIRCLECLICKGAME_H
#define CIRCLECLICKGAME_H

#include "../../core/BaseModule.h"

class CircleClickGame : public BaseModule
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID ModuleInterface_iid)
    Q_INTERFACES(ModuleInterface)

    Q_PROPERTY(int difficulty READ difficulty WRITE setDifficulty NOTIFY difficultyChanged)
    Q_PROPERTY(bool endlessMode READ endlessMode WRITE setEndlessMode NOTIFY endlessModeChanged)
    Q_PROPERTY(QUrl iconArrowPath READ iconArrowPath CONSTANT)
public:
    explicit CircleClickGame(QObject *parent = nullptr);

    QString name() const override;
    QString description() const override;
    QString manual() const override;
    QUrl qmlComponentUrl() const override;
    QUrl qmlSettingsUrl() const override;
    QString category() const override;
    QUrl iconUrl() const override;
    QUrl iconArrowPath() const;

    Q_INVOKABLE int difficulty() const;
    Q_INVOKABLE bool endlessMode() const;

public slots:
    void setDifficulty(int value);
    void setEndlessMode(bool value);


signals:
    void difficultyChanged();
    void endlessModeChanged();

private:
    int m_difficulty;
    bool m_endlessMode;
};

#endif // CIRCLECLICKGAME_H
