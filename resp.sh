#!/bin/bash

# ----------------------
# Color Variables
# ----------------------
RED="\033[0;31m"
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
LCYAN='\033[1;36m'
LBLUE='\033[1;34m'
LGREY='\033[0;37m'
BLACK='\033[0;30m'
DGREY='\033[1;30m'
NC='\033[0m' # No Color

# --------------------------------------
# Prompts for configuration preferences
# --------------------------------------

# Package Manager Prompt
echo
echo -e "⌛️ Initializing ${LCYAN}RESP(React + ESLint + Prettier) ${NC}CLI ⏳"
echo

# Check for valid package.json
echo -e "🔍 Searching for ${LBLUE}package.json${NC}"
if [ -e package.json ]; then
  echo -e "✅ ${GREEN}Found package.json${NC}"
else
  echo -e ${RED}"⭕ Error! No package.json found${NC}"
  echo -e "${YELLOW}💡 Tip: Create one with npm init${NC}"
  exit
fi
echo

# Checks for existing eslintrc files
echo -e "🔍 Searching for existing${LBLUE} ESLint${NC}"
if [ -f ".eslintrc.js" -o -f ".eslintrc.yaml" -o -f ".eslintrc.yml" -o -f ".eslintrc.json" -o -f ".eslintrc" ]; then
  echo -e "${RED}⭕ Existing ESLint config file(s) found:${NC}"
  ls -a .eslint* | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} There is loading priority when more than one config file is present: https://eslint.org/docs/user-guide/configuring#configuration-file-formats"
  echo
  exit
else
  echo -e "✅${GREEN} No existing ESLint file found${NC}"
fi
echo

echo -e "🚀${LCYAN} Preparing configuration settings...${NC}"
echo

# Check for package manager
echo -e "🧐 Which ${LBLUE}package manager${NC} are you using?"
select package_command_choices in "npm" "Yarn" "Cancel"; do
  case $package_command_choices in
  npm)
    pkg_cmd='npm install'
    break
    ;;
  Yarn)
    pkg_cmd='yarn add'
    break
    ;;
  Cancel)
    echo -e "⭕ Oops! Something went wrong"
    exit
    ;;
  esac
done
echo -e "🙂 You are using ${GREEN}${package_command_choices}${NC}"
echo

# File Format Prompt
echo -e "🧐 Which ${LBLUE}ESLint format${NC} do you prefer?"
select config_extension in ".js" ".json" "Cancel"; do
  case $config_extension in
  .js)
    config_opening='module.exports = {'
    break
    ;;
  .json)
    config_opening='{'
    break
    ;;
  Cancel)
    echo -e "⭕ Oops! Something went wrong"
    exit
    ;;
  esac
done
echo -e "🙂 Your preffered format is ${GREEN}${config_extension}${NC}"
echo

# Style guide prompt
echo -e "🧐 Which ${LBLUE}Style guide ${NC}do you prefer?"
select style_guides in "Standard(default)" "Airbnb" "Google"; do
  case $style_guides in
  Standard\(default\))
    guide='Standard'
    break
    ;;
  Airbnb)
    guide='Airbnb'
    break
    ;;
  Google)
    guide='Google'
    break
    ;;
  esac
done
echo -e "🙂 Your preffered style guide is ${GREEN}${guide}${NC}"
echo

# Style guide prompt
echo -e "🧐 You want ${LBLUE}Prettier ${NC}to be installed?"
select prettier_config in "Yes" "No"; do
  case $prettier_config in
  Yes)
    prettier_option='yes'
    break
    ;;
  No)
    prettier_option='no'
    break
    ;;
  esac
done
echo -e "🙂 Preffering Prettier ${GREEN}${prettier_option}${NC}"
echo

# Style guide prompt
echo -e "🧐 You want ${LBLUE}JSS Linting ${NC}to be installed?"
select stylelint_config in "Yes" "No"; do
  case $stylelint_config in
  Yes)
    stylelint_option='yes'
    break
    ;;
  No)
    stylelint_option='no'
    break
    ;;
  esac
done
echo -e "🙂 Preffering JSS Linting ${GREEN}${stylelint_option}${NC}"
echo

# Start the lint configurations
echo -e "📢 Creating lint files from the configuration..."

declare -i step=1
declare -i total_steps=6
echo -e "💡 ${DGREY}[${step}/5] ${LCYAN}Installing ESLint${NC}"
$pkg_cmd -D eslint
step+=1

# Install style guides
echo -e "💡 ${DGREY}[${step}/${total_steps}] ${LCYAN}Installing style guide${NC}"
if [ "$guide" == "Airbnb" ]; then
  $pkg_cmd -D eslint-plugin-react eslint-config-airbnb eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-react-hooks
elif [ "$guide" == "Google" ]; then
  $pkg_cmd -D eslint-config-google eslint-plugin-react
else
  $pkg_cmd -D eslint-plugin-react eslint-config-standard eslint-plugin-import eslint-plugin-node eslint-plugin-promise
fi
step+=1

# Install prettier
if [ "$prettier_option" == "yes" ]; then
  if [ -f ".prettierrc.js" -o -f "prettier.config.js" -o -f ".prettierrc.yaml" -o -f ".prettierrc.yml" -o -f ".prettierrc.json" -o -f ".prettierrc.toml" -o -f ".prettierrc" ]; then
    configure_prettier=false
    ls -a | grep "prettier*" | xargs -n 1 basename
    echo -e "⭕ ${DGREY}[${step}/${total_steps}] ${LCYAN}Existing Prettier found.Skipping Prettier setup${NC}"
  else
    echo -e "💡 ${DGREY}[${step}/${total_steps}] ${LCYAN}Installing Prettier${NC}"
    configure_prettier=true
    $pkg_cmd -D prettier eslint-config-prettier eslint-plugin-prettier
  fi
  step+=1
else
  configure_prettier=false
  echo -e "💡 ${DGREY}[${step}/${total_steps}] ${LCYAN}Skipping Prettier setup${NC}"
  step+=1
fi

# Perform Configration
echo -e "💡 ${DGREY}[${step}/${total_steps}] ${LCYAN}Perform Configuration${NC}"
if [ "$configure_prettier" == false ] && [ "$guide" == "Airbnb" ]; then
  >".eslintrc${config_extension}"
  echo ${config_opening}'
  "env": {
    "browser": true,
    "es2021": true,
    "commonjs": true
  },
  "extends": ["plugin:react/recommended", "airbnb"],
  "parserOptions": {
    "ecmaFeatures": {
      "jsx": true
    },
    "ecmaVersion": 12,
    "sourceType": "module"
  },
  "plugins": ["react"],
  "rules": {}
}' >>.eslintrc${config_extension}
elif [ "$configure_prettier" == false ] && [ "$guide" == "Google" ]; then
  >".eslintrc${config_extension}"
  echo ${config_opening}'
  "env": {
    "browser": true,
    "es2021": true,
    "commonjs": true
  },
  "extends": ["plugin:react/recommended", "google"],
  "parserOptions": {
    "ecmaFeatures": {
      "jsx": true
    },
    "ecmaVersion": 12,
    "sourceType": "module"
  },
  "plugins": ["react"],
  "rules": {}
}' >>.eslintrc${config_extension}
elif [ "$configure_prettier" == false ] && [ "$guide" == "Standard" ]; then
  >".eslintrc${config_extension}"
  echo ${config_opening}'
  "env": {
    "browser": true,
    "es2021": true,
    "commonjs": true
  },
  "extends": ["plugin:react/recommended", "standard"],
  "parserOptions": {
    "ecmaFeatures": {
      "jsx": true
    },
    "ecmaVersion": 12,
    "sourceType": "module"
  },
  "plugins": ["react"],
  "rules": {}
}' >>.eslintrc${config_extension}
elif [ "$configure_prettier" == true ] && [ "$guide" == "Airbnb" ]; then
  >".prettierrc.json"
  echo '{
  "printWidth": 80,
  "singleQuote": true,
  "trailingComma": "all"
}' >>.prettierrc.json
  >".eslintrc${config_extension}"
  echo ${config_opening}'
  "env": {
    "browser": true,
    "es2021": true,
    "commonjs": true
  },
  "extends": [
    "airbnb",
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
}' >>.eslintrc${config_extension}
elif [ "$configure_prettier" == true ] && [ "$guide" == "Google" ]; then
  >".prettierrc.json"
  echo '{
  "printWidth": 80,
  "singleQuote": true,
  "trailingComma": "all"
}' >>.prettierrc.json
  >".eslintrc${config_extension}"
  echo ${config_opening}'
  "env": {
    "browser": true,
    "es2021": true,
    "commonjs": true
  },
  "extends": [
    "google",
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
}' >>.eslintrc${config_extension}
elif [ "$configure_prettier" == true ] && [ "$guide" == "Standard" ]; then
  echo "I am in"
  >".prettierrc.json"
  echo '{
  "printWidth": 80,
  "singleQuote": true,
  "trailingComma": "all"
}' >>.prettierrc.json
  >".eslintrc${config_extension}"
  echo ${config_opening}'
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
}' >>.eslintrc${config_extension}
fi
step+=1

# Install and cofigure stylelint
if [ "$stylelint_option" == "yes" ]; then
  echo -e "💡 ${DGREY}[${step}/${total_steps}] ${LCYAN}Installing and Configuring Stylelint${NC}"
  $pkg_cmd -D stylelint stylelint-config-recommended stylelint-config-styled-components stylelint-processor-styled-components
  >".stylelintrc.json"
  echo '{
  "extends": "stylelint-config-recommended",
  "rules": {}
}' >>.stylelintrc.json
  step+=1
else
  echo -e "💡 ${DGREY}[${step}/${total_steps}] ${LCYAN}Skipping Stylelint setup${NC}"
  step+=1
fi

# Add Lint scripts to package.json
echo -e "💡 ${DGREY}[${step}/${total_steps}] ${LCYAN}Adding Lint scripts to package.json${NC}"
touch tmp.json
if [ "$stylelint_option" == "yes" ]; then
  sed -e '/"scripts": {/a\
    "lint:js": "eslint \\"src/**/*.{js,jsx}\\"",\
    "lint:css": "stylelint \\"src/**/*.js\\"",\
    "lint": "npm run lint:js && npm run lint:css",
  ' package.json >tmp.json
else
  sed -e '/"scripts": {/a\
    "lint:js": "eslint \\"src/**/*.{js,jsx}\\"",,
  ' package.json >tmp.json
fi
cat tmp.json >package.json
rm tmp.json

echo
echo -e "${LCYAN}npm run lint:js"
echo -e "${NC}👍 Checks for lint errors in the JS"
echo

echo -e "${LCYAN}npm run lint:css"
echo -e "${NC}👉 Checks for lint errors in the JSS"
echo

echo -e "${LCYAN}npm run lint"
echo -e "${NC}🤙 Checks for lint errors in the both JS and JSS"
echo

echo -e "🔴 Finishing the Lint setup..."
echo -e "✅ Setup Completed"
echo -e "🌟 ${GREEN}Happy Linting!!! 😇💫"
echo -e "${NC}Please add a 🌟 here: https://github.com/msgtobala/RESP-CLI/blob/master/resp.sh"
echo
