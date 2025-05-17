#ifndef MODULELOADER_H
#define MODULELOADER_H

#include <QObject>
#include <QVector>
#include <QString>
#include <QPluginLoader>

#include "ModuleInterface.h"

class ModuleLoader
{
public:
    explicit ModuleLoader(const QString& modulePath);        //конструктор принимающий путь к модулям
    ~ModuleLoader();
    QVector<ModuleInterface*> loadModules();        //метод дял поиска и загрузки всех модулей
private:
    QString m_modulesPath;                          //путь до модулей
    QVector<QPluginLoader*> m_pluginLoaders;        //вектор указателей на загрузчики

};

#endif // MODULELOADER_H
