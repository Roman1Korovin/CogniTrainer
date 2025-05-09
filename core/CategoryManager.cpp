#include "CategoryManager.h"


const QList<Category> CategoryManager::categories = {
    Category("Реакция", ":/icons/education.png"),
    Category("Логика", ":/icons/games.png"),
    Category("Память", ":/icons/music.png")
};

const QList<Category>& CategoryManager::getAvailableCategories() {
    return categories;
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
