# Custom docker images

Contains docker images for an apache server running different versions of PHP.

PHP (various versions, based on tag) is prepackaged with extensions (APC, PDO_MYSQL, MYSQLI).

Apache has rewrite headers module enabled.

Includes composer package manager.

@todo - Add xdebug php extension, xdebug ports and readme 
@todo - Add Drush, AWS CLI tools

See various tags for different PHP versions. These dockerfiles are linked automated dockerhub builds - https://cloud.docker.com/repository/docker/robertbourne/php-extras-apache/