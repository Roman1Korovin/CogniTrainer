#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <qqml.h>
#include "core/ModuleLoader.h"
#include "core/CategoryManager.h"


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


    //Преобразуем в QVariantList
    QVariantList moduleList;
    for (ModuleInterface* m : modules) {
        QObject* obj = dynamic_cast<QObject*>(m);
        if (obj) {
            moduleList << QVariant::fromValue(obj);
        }
    }

    //Пробрасываем  список имен в QML-контекст
    engine.rootContext()->setContextProperty("moduleList", moduleList);


    CategoryManager categoryManager;
    engine.rootContext()->setContextProperty("categoryManager", &categoryManager);


    //загружаем коневой qml файл
    engine.loadFromModule("CogniTrainer", "Main");

    return app.exec();
}
