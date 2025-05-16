#include "CategoryManager.h"
#include "Category.h"

CategoryManager::CategoryManager(QObject* parent) : QObject(parent) {

    m_categories.append(new Category("Реакция", "assets/backgrounds//ReactionTrainer.png", this));
    m_categories.append(new Category("Логика", ":/icons/logic.png", this));
    m_categories.append(new Category("Память", ":/icons/memory.png", this));

}

QList<QObject *> CategoryManager::categories() const
{
    return m_categories;
}


bool CategoryManager::isValidCategory(const QString& name)
{
    for (auto obj : m_categories) {
        auto category = qobject_cast<Category*>(obj);
        if (category && category->name().compare(name, Qt::CaseInsensitive) == 0)
            return true;
    }
    return false;
}
