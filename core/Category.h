#ifndef CATEGORY_H
#define CATEGORY_H

#include <QObject>


class Category: public QObject {
    Q_OBJECT
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString imageUrl READ imageUrl CONSTANT)


public:
    Category(const QString& name, const QString& imageUrl,QObject* parent = nullptr)
        : QObject(parent), m_name(name), m_imageUrl(imageUrl) {}

    QString name() const { return m_name; }
    QString imageUrl() const { return m_imageUrl; }

private:
    QString m_name;
    QString m_imageUrl;
};

#endif // CATEGORY_H
