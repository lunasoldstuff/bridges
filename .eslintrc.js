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
    'no-multi-spaces': [
      'error',
      {
        ignoreEOLComments: false,
        exceptions: {
          VariableDeclarator: true,
        },
      },
    ],
  },
};
