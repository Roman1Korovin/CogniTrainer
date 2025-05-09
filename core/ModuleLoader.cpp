#include "ModuleLoader.h"
#include "CategoryManager.h"
#include <QDir>
#include <qDebug>

// Класс сканирует указанную директорию на наличие плагинов(модулей) и загружает их
ModuleLoader::ModuleLoader(const QString& modulePath)
    : m_modulesPath(modulePath) {}

QVector<ModuleInterface*> ModuleLoader::loadModules()
{
    QVector<ModuleInterface*> modules;

    QDir dir(m_modulesPath);

    //фильтруем по расширения для Win и Linux/mac
    QStringList filter =
    {
#ifdef Q_OS_WIN
        "*.dll"
#else
        "*.so"
#endif
    };

    //перебираем все подходящие файлы, загружаем плагин по fulePath и создаем объект(модуль) из плагина
    for(const QString& fileName : dir.entryList(filter, QDir::Files))
    {
        QString filePath = dir.absoluteFilePath(fileName);
        QPluginLoader* loader = new QPluginLoader(filePath);        //создается обект-загрузчик
        QObject* plugin = loader->instance();                       //instance создает объект, который реализует интерфейс плагина

        //проверяем, удалось ли создать объект
        if(plugin)
        {
            auto* module = qobject_cast<ModuleInterface*>(plugin);  //приводим объект к интерфейсу ModuleInterface

            if(module)
            {
                // Проверяем правильность категории модуля,
                if (!CategoryManager::isValidCategory(module->category())) {
                    qCritical() << "Несуществующая категория в модуле"<<module->name()<< ":" << module->category()
                                << ". Если вы хотите доабвить новую категорию, сделайте это в классе CategoryManager.";
                    delete module;
                    module = nullptr;
                    delete loader;
                    continue;
                }
                modules.append(module);                             //добавляем модуль в вектор
                m_pluginLoaders.append(loader);                     //добавляем загрузчик в список, чтобы модуль не выгрузился автоматически
                qDebug() << "Модуль загружен:" << module->name();
            }
            else
            {
                qCritical() << "Ошибка: не реализует ModuleInterface:" <<fileName;
                delete loader;
            }
        }
        else
        {
            qCritical() << "Ошибка загрузки" <<loader->errorString();
            delete loader;
        }
    }
    return modules;

}


