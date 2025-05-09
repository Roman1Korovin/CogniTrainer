#ifndef CATEGORY_H
#define CATEGORY_H

#include <QString>
#include <QIcon>

struct Category {
    QString name;
    QIcon icon;

    Category(const QString& name, const QString& iconPath)
        : name(name), icon(QIcon(iconPath)) {}
};

#endif // CATEGORY_H
