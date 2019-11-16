#include <QGuiApplication>
#include <QObject>

#include <QQmlEngine>
#include <QQuickWindow>
#include <QQmlComponent>

int main(int argc, char* argv[]) {
    QGuiApplication app(argc, argv);

    QQmlEngine engine;
    QQmlComponent component(&engine, ":/main.qml");
    auto object = component.create();

    if (!object) {
        qCritical() << "Failed to create main component:";
        qCritical() << component.errors();
        return -1;
    }
    object->setParent(&component);

    auto window = qobject_cast<QQuickWindow*>(object);
    window->show();

    return app.exec();
}
