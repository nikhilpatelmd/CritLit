/**
 * Generates CSS from design tokens, replacing the Tailwind plugin approach.
 * Produces two files:
 *   - base/tokens.css       — :root custom properties for all design tokens
 *   - utilities/generated.css — utility classes derived from design tokens
 */

import fs from 'node:fs/promises';
import slugify from 'slugify';
import {clampGenerator} from '../utils/clamp-generator.js';

import colorTokens from '../../_data/designTokens/colors.json' with {type: 'json'};
import borderRadiusTokens from '../../_data/designTokens/borderRadius.json' with {type: 'json'};
import fontTokens from '../../_data/designTokens/fonts.json' with {type: 'json'};
import spacingTokens from '../../_data/designTokens/spacing.json' with {type: 'json'};
import textSizeTokens from '../../_data/designTokens/textSizes.json' with {type: 'json'};
import textLeadingTokens from '../../_data/designTokens/textLeading.json' with {type: 'json'};
import textWeightTokens from '../../_data/designTokens/textWeights.json' with {type: 'json'};

const slug = text => slugify(text, {lower: true});

// Quote multi-word font names; leave single-word and generic families unquoted
const fontFamilyValue = fonts =>
  fonts.map(f => (f.includes(' ') ? `"${f}"` : f)).join(', ');

/**
 * Generates the :root block of CSS custom properties from all design tokens.
 */
export function generateTokensRootCss() {
  const spacing = clampGenerator(spacingTokens.items);
  const textSizes = clampGenerator(textSizeTokens.items);

  let css = '/* Generated from design tokens — do not edit directly */\n:root {\n';

  colorTokens.items.forEach(({name, value}) => {
    css += `  --color-${slug(name)}: ${value};\n`;
  });

  borderRadiusTokens.items.forEach(({name, value}) => {
    css += `  --border-radius-${slug(name)}: ${value};\n`;
  });

  spacing.forEach(({name, value}) => {
    css += `  --space-${slug(name)}: ${value};\n`;
  });

  textSizes.forEach(({name, value}) => {
    css += `  --size-${slug(name)}: ${value};\n`;
  });

  textLeadingTokens.items.forEach(({name, value}) => {
    css += `  --leading-${slug(name)}: ${value};\n`;
  });

  fontTokens.items.forEach(({name, value}) => {
    css += `  --font-${slug(name)}: ${fontFamilyValue(value)};\n`;
  });

  textWeightTokens.items.forEach(({name, value}) => {
    css += `  --font-${slug(name)}: ${value};\n`;
  });

  css += '}\n';
  return css;
}

/**
 * Generates utility classes from design tokens.
 * Covers: text sizes, font families, font weights, line heights,
 * margin/padding (using logical properties), and CUBE CSS spacing overrides.
 */
export function generateTokensUtilitiesCss() {
  const spacing = clampGenerator(spacingTokens.items);
  const textSizes = clampGenerator(textSizeTokens.items);

  let css = '/* Generated utility classes from design tokens — do not edit directly */\n\n';

  // Text size utilities
  css += '/* Text sizes */\n';
  textSizes.forEach(({name, value}) => {
    css += `.text-${slug(name)} { font-size: ${value}; }\n`;
  });
  css += '\n';

  // Font family utilities
  css += '/* Font families */\n';
  fontTokens.items.forEach(({name, value}) => {
    css += `.font-${slug(name)} { font-family: ${fontFamilyValue(value)}; }\n`;
  });
  css += '\n';

  // Font weight utilities
  css += '/* Font weights */\n';
  textWeightTokens.items.forEach(({name, value}) => {
    css += `.font-${slug(name)} { font-weight: ${value}; }\n`;
  });
  css += '\n';

  // Line height utilities
  css += '/* Line heights */\n';
  textLeadingTokens.items.forEach(({name, value}) => {
    css += `.leading-${slug(name)} { line-height: ${value}; }\n`;
  });
  css += '\n';

  // Spacing utilities using CSS logical properties
  const spacingGroups = [
    ['mt', 'margin-block-start'],
    ['mb', 'margin-block-end'],
    ['my', 'margin-block'],
    ['mx', 'margin-inline'],
    ['p', 'padding'],
    ['pt', 'padding-block-start'],
    ['pb', 'padding-block-end'],
    ['py', 'padding-block'],
    ['px', 'padding-inline']
  ];

  spacingGroups.forEach(([prefix, property]) => {
    css += `/* ${property} */\n`;
    spacing.forEach(({name, value}) => {
      css += `.${prefix}-${slug(name)} { ${property}: ${value}; }\n`;
    });
    // auto variant for margin utilities
    if (prefix.startsWith('m')) {
      css += `.${prefix}-auto { ${property}: auto; }\n`;
    }
    css += '\n';
  });

  // CUBE CSS custom property overrides (set component-level variables from markup)
  const cubeOverrides = [
    ['flow-space', '--flow-space'],
    ['region-space', '--region-space'],
    ['gutter', '--gutter']
  ];

  cubeOverrides.forEach(([prefix, property]) => {
    css += `/* ${property} overrides */\n`;
    spacing.forEach(({name, value}) => {
      css += `.${prefix}-${slug(name)} { ${property}: ${value}; }\n`;
    });
    css += '\n';
  });

  return css;
}

/**
 * Writes both generated CSS files to disk.
 * Called during the build pipeline before PostCSS runs.
 */
export async function writeTokensCss() {
  const rootCss = generateTokensRootCss();
  const utilitiesCss = generateTokensUtilitiesCss();

  const rootPath = new URL(
    '../../assets/css/global/base/tokens.css',
    import.meta.url
  );
  const utilitiesPath = new URL(
    '../../assets/css/global/utilities/generated.css',
    import.meta.url
  );

  await Promise.all([
    fs.writeFile(rootPath, rootCss, 'utf-8'),
    fs.writeFile(utilitiesPath, utilitiesCss, 'utf-8')
  ]);
}
