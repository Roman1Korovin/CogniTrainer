#include "CategoryManager.h"

#include "Category.h"

CategoryManager::CategoryManager(QObject* parent) : QObject(parent) {

    m_categories.append(new Category("Реакция", "qrc:/assets/backgrounds//ReactionTrainer.png", this));
    m_categories.append(new Category("Память", ":/icons/logic.png", this));
    m_categories.append(new Category("Внимание", ":/icons/memory.png", this));
    m_categories.append(new Category("Письмо и ввод", ":/icons/memory.png", this));

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
