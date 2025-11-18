/** All relevant pages as a collection for sitemap.xml */
export const showInSitemap = collection => {
  return collection.getFilteredByGlob('./src/**/*.{md,njk}');
};

/** All blog posts as a collection. */
export const getAllPosts = collection => {
  return collection.getFilteredByGlob('./src/posts/**/*.md').reverse();
};

/** All study summaries as a collection. */
export const getAllStudies = collection => {
  // Filters for all Markdown files in the src/studies folder, similar to getAllPosts.
  return collection.getFilteredByGlob('./src/studies/**/*.md').reverse();
};

/** All tags from all posts as a collection - excluding custom collections */
export const tagList = collection => {
  const tagsSet = new Set();
  collection.getAll().forEach(item => {
    if (!item.data.tags) return;
    item.data.tags.filter(tag => !['posts', 'docs', 'all'].includes(tag)).forEach(tag => tagsSet.add(tag));
  });
  return Array.from(tagsSet).sort();
};

/** All unique 'condition' values from study summaries. */
export const uniqueConditions = collection => {
  const conditionsSet = new Set();
  // Only check files that belong to the 'studies' collection
  collection.getFilteredByGlob('./src/studies/**/*.md').forEach(item => {
    // Assumes 'condition' is a string or array in the study's front matter
    if (item.data.condition) {
      const conditions = Array.isArray(item.data.condition) ? item.data.condition : [item.data.condition];
      conditions.forEach(condition => conditionsSet.add(condition));
    }
  });
  // Returns a sorted array of unique condition names (e.g., ['ARDS', 'sepsis', ...])
  return Array.from(conditionsSet).sort();
};

/** All unique 'topic' values from study summaries. */
export const uniqueTopics = collection => {
  const topicsSet = new Set();
  // Only check files that belong to the 'studies' collection
  collection.getFilteredByGlob('./src/studies/**/*.md').forEach(item => {
    // Assumes 'topic' is a string or array in the study's front matter
    if (item.data.topic) {
      const topics = Array.isArray(item.data.topic) ? item.data.topic : [item.data.topic];
      topics.forEach(topic => topicsSet.add(topic));
    }
  });
  // Returns a sorted array of unique topic names (e.g., ['blood pressure control', 'hemostasis', ...])
  return Array.from(topicsSet).sort();
};
