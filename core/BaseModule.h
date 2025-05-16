// BaseModule.h
#ifndef BASEMODULE_H
#define BASEMODULE_H

#include <QObject>
#include "../interfaces/ModuleInterface.h"

class BaseModule : public QObject, public ModuleInterface
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString description READ description CONSTANT)
    Q_PROPERTY(QUrl qmlComponentUrl READ qmlComponentUrl CONSTANT)
    Q_PROPERTY(QString category READ category CONSTANT)

public:
    using QObject::QObject; // использовать конструктор QObject
};

#endif // BASEMODULE_H
