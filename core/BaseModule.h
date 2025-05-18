// BaseModule.h
#ifndef BASEMODULE_H
#define BASEMODULE_H

#include <QObject>

#include "ModuleInterface.h"

class BaseModule : public QObject, public ModuleInterface
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString category READ category CONSTANT)
    Q_PROPERTY(QString description READ description CONSTANT)
    Q_PROPERTY(QString manual READ manual CONSTANT)
    Q_PROPERTY(QUrl qmlComponentUrl READ qmlComponentUrl CONSTANT)
    Q_PROPERTY(QUrl qmlSettingsUrl READ qmlSettingsUrl CONSTANT)
    Q_PROPERTY(QUrl iconUrl READ iconUrl CONSTANT)

public:
    using QObject::QObject; // использовать конструктор QObject
};

#endif // BASEMODULE_H
