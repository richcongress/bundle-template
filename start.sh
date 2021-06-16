#!/usr/bin/env bash

echo "Please enter the name of the bundle (ex: AwesomeThing): "
read name

name_with_underscore=`echo "$name" | sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\L\2/g' | tr '[:upper:]' '[:lower:]'}`
name_with_dash="${name_with_underscore/_/-}"

# Add static analysis configuration
ln -sr ./vendor/richcongress/static-analysis/configs/phpstan.neon ./
ln -sr ./vendor/richcongress/static-analysis/configs/phpinsights.php ./
ln -sr ./vendor/richcongress/static-analysis/configs/php-cs-fixer.dist.php ./.php-cs-fixer.dist.php

# Change file name
mv src/RichIdTemplateBundle.php "src/RichId${name}Bundle.php"
mv src/DependencyInjection/RichIdTemplateExtension.php "src/DependencyInjection/RichId${name}Extension.php"

# Replace all strings
find . -path ./.git -prune -false -type f -exec sed -i "s/TemplateBundle/${name}Bundle/g" {} +
find . -path ./.git -prune -false -type f -exec sed -i "s/TemplateExtension/${name}Extension/g" {} +
find . -path ./.git -prune -false -type f -exec sed -i "s/The RichId Template Bundle/The RichId ${name} Bundle/g" {} +
find . -path ./.git -prune -false -type f -exec sed -i "s/template-bundle/${name_with_dash}-bundle/g" {} +
find . -path ./.git -prune -false -type f -exec sed -i "s/rich_id_template/rich_id_${name_with_dash}/g" {} +

# Delete script
rm ./start.sh

# Output message
echo "The bundle is almost ready!"
echo "Please do the following actions right now"
echo "- Add the Secret \`COVERALLS_SECRET\` in the Github Actions, you can get it here: https://coveralls.io/repos/new"
echo "- Add the bundle to Code Climate quality tool and update its badge: https://codeclimate.com/dashboard"