#ifndef MODULEINTERFACE_H
#define MODULEINTERFACE_H

#include <QString>
#include <QUrl>
#include <QtPlugin>

// Абстрактный клас для реализации модулей
class ModuleInterface {
public:
    virtual ~ModuleInterface() {}
    virtual QString name() const = 0;
    virtual QString description() const = 0;
    virtual QString manual() const = 0;
    virtual QString category() const = 0;
    virtual QUrl qmlComponentUrl() const = 0;
    virtual QUrl qmlSettingsUrl() const = 0;
    virtual QUrl iconUrl() const = 0;
};

#define ModuleInterface_iid "org.cognitivetrainer.ModuleInterface"
Q_DECLARE_INTERFACE(ModuleInterface, ModuleInterface_iid)

#endif // MODULEINTERFACE_H
