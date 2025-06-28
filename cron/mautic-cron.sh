#!/bin/bash
php /var/www/html/bin/console mautic:segments:update
php /var/www/html/bin/console mautic:campaigns:update
php /var/www/html/bin/console mautic:campaigns:trigger
php /var/www/html/bin/console mautic:emails:send
