#include <QApplication>
#include <QMainWindow>
#include <QWidget>
#include <QVBoxLayout>
#include <iostream>
using namespace std;

class Main_window : public QMainWindow {
    Q_OBJECT
public:
    Main_window() {
        setWindowFlag(Qt::Dialog);


        auto central_widget = new QWidget();
        auto layout = new QVBoxLayout();
        central_widget->setLayout(layout);
        setCentralWidget(central_widget);
    }
};

int main(int argc, char* argv[]) {
    QApplication app(argc, argv);
    Main_window window;
    window.show();
    app.exec();
    return 0;
}

#include "main.moc"
