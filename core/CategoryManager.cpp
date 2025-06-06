#include "CategoryManager.h"

#include "Category.h"

CategoryManager::CategoryManager(QObject* parent) : QObject(parent) {

    m_categories.append(new Category("Реакция", "qrc:/assets/icons/ReactionIcon.png", this));
    m_categories.append(new Category("Память", "qrc:/assets/icons/MemoryIcon.png", this));
    m_categories.append(new Category("Внимание", "qrc:/assets/icons/AttentionIcon.png", this));
    m_categories.append(new Category("Письмо и ввод", "qrc:/assets/icons/KeyboardIcon.png", this));


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

    if (name.trimmed().compare("Тест", Qt::CaseInsensitive) == 0) {
        return true;  // Автоматически пропускаем категорию "Тест"
    }

    return false;
}
