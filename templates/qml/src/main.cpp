#include <QDebug>
#include <QObject>
#include <QGuiApplication>

#include <QQmlEngine>
#include <QQmlComponent>

int main(int argc, char* argv[]) {
    QGuiApplication app(argc, argv);

    QQmlEngine engine;
    QQmlComponent component(&engine, "qrc:/main.qml");
    auto object = component.create();

    if (!object) {
        qCritical() << "Failed to create main component:";
        qCritical() << component.errors();
        return -1;
    }
    object->setParent(&component);

    return app.exec();
}
