module.exports = {
  root: true,
  parser: 'babel-eslint',
  parserOptions: {
    ecmaVersion: 2018,
  },
  extends: 'airbnb',
  env: {
    browser: true,
  },
  rules: {
    'jsx-quotes': ['error', 'prefer-single'],
    'max-len': [
      'error',
      256,
      2,
      {
        ignoreUrls: true,
        ignoreComments: false,
        ignoreRegExpLiterals: true,
        ignoreStrings: true,
        ignoreTemplateLiterals: true,
      },
    ],
    'no-multi-spaces': [
      'error',
      {
        ignoreEOLComments: false,
        exceptions: {
          VariableDeclarator: true,
        },
      },
    ],
    'space-before-function-paren': [
      'error',
      {
        anonymous: 'always',
        named: 'always',
        asyncArrow: 'always',
      },
    ],
  },
};
