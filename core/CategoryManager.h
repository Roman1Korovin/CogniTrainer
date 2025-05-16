#ifndef CATEGORYMANAGER_H
#define CATEGORYMANAGER_H


#include <QList>
#include <QObject>

class CategoryManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> categories READ categories NOTIFY categoriesChanged)

public:
    explicit CategoryManager(QObject* parent = nullptr);

    QList<QObject*> categories() const;

    bool isValidCategory(const QString& name) ;

signals:
    void categoriesChanged();
private:
    QList<QObject*> m_categories;
};

#endif // CATEGORYMANAGER_H
