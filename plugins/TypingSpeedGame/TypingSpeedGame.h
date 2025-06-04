#ifndef TYPINGSPEEDGAME_H
#define TYPINGSPEEDGAME_H

#include "../../core/BaseModule.h"

class TypingSpeedGame : public BaseModule
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID ModuleInterface_iid)
    Q_INTERFACES(ModuleInterface)

    Q_PROPERTY(QUrl iconArrowDarkUrl READ iconArrowDarkUrl CONSTANT)
    Q_PROPERTY(QUrl iconArrowLightUrl READ iconArrowLightUrl CONSTANT)
    Q_PROPERTY(QStringList sentences READ sentences NOTIFY sentencesChanged)


public:
    explicit TypingSpeedGame(QObject *parent = nullptr);

    QString name() const override;
    QString description() const override;
    QString manual() const override;
    QUrl qmlComponentUrl() const override;
    QUrl qmlSettingsUrl() const override;
    QString category() const override;
    QUrl iconUrl() const override;
    QUrl iconArrowDarkUrl() const;
    QUrl iconArrowLightUrl() const;
    QStringList sentences() const;
signals:
    void sentencesChanged();

private:
    QStringList m_sentences;

};

#endif // TYPINGSPEEDGAME_H
