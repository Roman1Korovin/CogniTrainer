#ifndef DIGITSPANTEST_H
#define DIGITSPANTEST_H

#include "../../core/BaseModule.h"

class DigitSpanTest : public BaseModule
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID ModuleInterface_iid)
    Q_INTERFACES(ModuleInterface)

    Q_PROPERTY(int age READ age WRITE setAge NOTIFY ageChanged)
    Q_PROPERTY(QUrl iconArrowDarkUrl READ iconArrowDarkUrl CONSTANT)
    Q_PROPERTY(QUrl iconArrowLightUrl READ iconArrowLightUrl CONSTANT)


public:

    explicit DigitSpanTest(QObject *parent = nullptr);

    QString name() const override;
    QString description() const override;
    QString manual() const override;
    QUrl qmlComponentUrl() const override;
    QUrl qmlSettingsUrl() const override;
    QString category() const override;
    QUrl iconUrl() const override;
    QUrl iconArrowDarkUrl() const;
    QUrl iconArrowLightUrl() const;

    Q_INVOKABLE int age() const;


public slots:
    void setAge(int value);

signals:
    void ageChanged();

private:
    int m_age;
};

#endif // DIGITSPANTEST_H
