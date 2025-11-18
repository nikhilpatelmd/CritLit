// src/_config/filters/array-filter.js

/**
 * Filters a collection where an array property includes a specific value.
 *
 * Usage: {{ collections.allStudies | collectionWhere('data.condition', currentConditionName) }}
 *
 * @param {Array} collection - The collection of items (e.g., collections.allStudies).
 * @param {string} keyPath - The path to the array property (e.g., 'data.condition').
 * @param {string} targetValue - The value to check for inclusion (e.g., 'Intracerebral Hemorrhage').
 * @returns {Array} The filtered array of collection items.
 */
export const collectionWhere = (collection, keyPath, targetValue) => {
  if (!Array.isArray(collection)) {
    return [];
  }

  return collection.filter(item => {
    // Utility function to safely get nested property value (e.g., item['data']['condition'])
    const getNestedValue = (obj, path) => {
      // Split the path (e.g., 'data.condition') and traverse the object
      return path.split('.').reduce((acc, part) => acc && acc[part], obj);
    };

    const conditionArray = getNestedValue(item, keyPath);

    // Check if the property is an array and if it includes the target value
    return Array.isArray(conditionArray) && conditionArray.includes(targetValue);
  });
};
