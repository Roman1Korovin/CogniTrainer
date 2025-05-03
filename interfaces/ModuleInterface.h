#ifndef MODULEINTERFACE_H
#define MODULEINTERFACE_H

#include <QString>
#include <QtQml/qqmlengine.h>

class ModuleInterface {
public:
    virtual ~ModuleInterface() {}

    virtual QString name() const = 0;
    virtual QString description() const = 0;
    virtual QUrl qmlComponentUrl() const = 0;
};

#define ModuleInterface_iid "org.cognitivetrainer.ModuleInterface"
Q_DECLARE_INTERFACE(ModuleInterface, ModuleInterface_iid)

#endif // MODULEINTERFACE_H
