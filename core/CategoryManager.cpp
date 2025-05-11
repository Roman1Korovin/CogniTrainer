#include "CategoryManager.h"


const QList<Category> CategoryManager::s_categories = {
    Category("Реакция", ":/icons/reaction.png"),
    Category("Логика", ":/icons/logic.png"),
    Category("Память", ":/icons/memory.png")
};

const QList<Category>& CategoryManager::getAvailableCategories() {
    return s_categories;
}

bool CategoryManager::isValidCategory(const QString& name)
{
    // Удаляем лишние пробелы в начале и в конце строки
    const QString trimmedName = name.trimmed();

    // Получаем список всех доступных категорий
    const auto& categories = getAvailableCategories();

    // Проверяем, есть ли категория с таким именем
    for (const Category& category : categories) {
        if (category.name.trimmed().compare(trimmedName, Qt::CaseInsensitive) == 0) {
            return true;
        }
    }

    return false;
}
