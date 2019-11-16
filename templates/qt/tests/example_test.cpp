#include <QTest>

class Example_test : public QObject {
    Q_OBJECT

private slots:
    void test_case();
};

void Example_test::test_case() {
    QCOMPARE(2 + 2, 4);
}

QTEST_MAIN(Example_test)

#include "example_test.moc"
