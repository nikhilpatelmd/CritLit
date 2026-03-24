# CritLit

A living repository of influential literature in critical care medicine.

## Technologies Used
- [Eleventy (11ty)](https://www.11ty.dev/) - A simpler static site generator.
- Node.js (v20.x or higher)
- JavaScript / Markdown / CSS

## Prerequisites
Ensure you have the following installed:
- Node.js (Version 20.x or higher is required)
- npm

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/nikhilpatelmd/CritLit.git
   cd CritLit
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Run Setup Scripts (Optional):**
   You can generate colors, favicons, and screenshots based on your configuration by running:
   ```bash
   npm run colors
   npm run favicons
   npm run screenshots
   ```

## Development

To start a local development server with hot-reload:
```bash
npm start
```

This will run the Eleventy server on `http://localhost:8080/` (or another available port, check your terminal output).

## Building for Production

To create a production-ready build of the site in the `dist` folder:
```bash
npm run build
```

## Testing

The project includes an accessibility testing suite using [pa11y-ci](https://github.com/pa11y/pa11y-ci). To run the tests:
```bash
npm run test:a11y
```

## Adding a New Study

Studies are stored in the `src/studies/` directory as Markdown files. To add a new study, create a new `.md` file in that directory using the following frontmatter template:

```markdown
---
acronym: STUDY_ACRONYM
title: Full Title of the Study
datePublished: YYYY-MM-DD
journal: Journal Name
doi: 10.1xxx/...
pmid: 12345678
trialRegistration: NCT...
fundingSource: Funding Body
condition:
  - Condition 1
topic:
  - Topic 1
pico: A brief formulation of the clinical question...
gist: |
  A robust summary or the "gist" of the study and its conclusions...
---

Additional article content or notes go here.
```

## License
This project is licensed under the terms of the ISC license. See the [LICENSE.MD](LICENSE.MD) file for more details.
