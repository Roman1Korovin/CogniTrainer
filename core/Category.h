#ifndef CATEGORY_H
#define CATEGORY_H

#include <QObject>


class Category: public QObject {
    Q_OBJECT
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString imagePath READ imagePath CONSTANT)


public:
    Category(const QString& name, const QString& imagePath,QObject* parent = nullptr)
        : QObject(parent), m_name(name), m_imagePath(imagePath) {}

    QString name() const { return m_name; }
    QString imagePath() const { return m_imagePath; }

private:
    QString m_name;
    QString m_imagePath;
};

#endif // CATEGORY_H
