#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "core/ModuleLoader.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    //защита от неудачной загрузки qml
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    //загружаем плагины
    ModuleLoader loader(QCoreApplication::applicationDirPath() + "/modules");
    QVector<ModuleInterface*> modules = loader.loadModules();


    QVariantList moduleList;

    for(auto* m : modules)
    {
        QVariantMap item;
        item["name"] = m->name();
        item["url"] = m->qmlComponentUrl().toString();
        moduleList.append(item);
    }

    //Пробрасываем  список имен в QML-контекст
    engine.rootContext()->setContextProperty("moduleList",moduleList);

    //загружаем коневой qml файл
    engine.loadFromModule("CogniTrainer", "Main");

    return app.exec();
}
