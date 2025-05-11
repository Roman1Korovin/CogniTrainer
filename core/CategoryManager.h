#ifndef CATEGORYMANAGER_H
#define CATEGORYMANAGER_H

#include "Category.h"
#include <QList>

class CategoryManager {
private:
     static const QList<Category> s_categories;
public:
    static const QList<Category>& getAvailableCategories();
    static bool isValidCategory(const QString& name);
};

#endif // CATEGORYMANAGER_H
