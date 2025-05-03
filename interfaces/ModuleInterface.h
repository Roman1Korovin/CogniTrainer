#ifndef MODULEINTERFACE_H
#define MODULEINTERFACE_H

#include <QString>
#include <QtQml/qqmlengine.h>

// Абстрактный клас для реализации модулей
class ModuleInterface {
public:
    virtual ~ModuleInterface() {}

    virtual QString name() const = 0;               //название модуля
    virtual QString description() const = 0;        //описание модуля
    virtual QUrl qmlComponentUrl() const = 0;       //пукть к QML компоненту
};

#define ModuleInterface_iid "org.cognitivetrainer.ModuleInterface"
Q_DECLARE_INTERFACE(ModuleInterface, ModuleInterface_iid)

#endif // MODULEINTERFACE_H
