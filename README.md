# RESP CLI

A CLI to simplify React ESLint setup. I built this CLI since I felt reinventing the wheel of ESLint for React is quite a repeated process.

Spoiler Alert!!!😜 - I am a Newbie to bash script. Please forgive me for the worst syntax. Also, feel free to contribute to improve it.

## Supported Flavours

1. Ubuntu
2. macOS
3. Windows(only with WSL).Read this to install WSL <https://www.thewindowsclub.com/how-to-run-sh-or-shell-script-file-in-windows-10>

## How to use

1. Navigate to your React project\
```cd <react_project>```

2. Run the below command\
```exec 3<&1;bash <&3 <(curl https://raw.githubusercontent.com/msgtobala/RESP-CLI/master/resp.sh 2> /dev/null)```

3. Select your configurations\
    * Package Manager - npm/yarn
    * ESLint format - .js/.json
    * Style guide - Standard/Airbnb/Google
    * Prettier - Yes/No
    * JSS Linting - Yes/No

4. That's it. Your ESLint is ready. Look for `eslintrc`, `stylelintrc`, `prettierrc` files in the project root directory.

----

## Packages

1. [ESLint](https://eslint.org/)
2. [Airbnb](https://github.com/airbnb/javascript/tree/master/react)
3. [Google](https://github.com/google/eslint-config-google)
4. [Standard](https://github.com/standard/eslint-config-standard)
5. [Prettier](https://prettier.io/)
6. [Stylelint](https://stylelint.io/)

## Dependencies

1. eslint
2. eslint-plugin-react
3. eslint-config-airbnb
4. eslint-plugin-import
5. eslint-plugin-jsx-a11y
6. eslint-plugin-react-hooks
7. eslint-config-google
8. eslint-config-standard
9. eslint-plugin-node
10. eslint-plugin-promise
11. prettier
12. eslint-config-prettier
13. eslint-plugin-prettier
14. stylelint
15. stylelint-config-recommended
16. stylelint-config-styled-components
17. stylelint-processor-styled-components

## Sample Generated Codes

### .eslintrc

```json
"env": {
    "browser": true,
    "es2021": true,
    "commonjs": true
  },
  "extends": [
    "standard",
    "plugin:prettier/recommended",
    "prettier/react"
  ],
  "parserOptions": {
    "ecmaFeatures": {
      "jsx": true
    },
    "ecmaVersion": 12,
    "sourceType": "module"
  },
  "plugins": ["prettier"],
  "rules": {
    "prettier/prettier": "error"
}
```

### .prettierrc

```json
{
  "printWidth": 80,
  "singleQuote": true,
  "trailingComma": "all"
}
```

### .stylelintrc

```json
{
  "extends": "stylelint-config-recommended",
  "rules": {}
}
```

## References

Read how I created this CLI
<https://balajisblog.com/adding-eslint-to-js-and-react/>

Read the detailed article on configuring ESLint
<https://balajisblog.com/adding-eslint-to-js-and-react/>
