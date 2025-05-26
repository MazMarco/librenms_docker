15 0 * * * cd /opt/librenms/ && bash daily.sh
*/5 * * * * php -f /opt/librenms/html/plugins/Weathermap/map-poller.php
33   */6  * * *   librenms    /opt/librenms/cronic /opt/librenms/discovery-wrapper.py 1
*/5  *    * * *   librenms    /opt/librenms/discovery.php -h new >> /dev/null 2>&1
*/5  *    * * *   librenms    /opt/librenms/cronic /opt/librenms/poller-wrapper.py 16
*    *    * * *   librenms    /opt/librenms/alerts.php >> /dev/null 2>&1
*/5  *    * * *   librenms    /opt/librenms/poll-billing.php >> /dev/null 2>&1
01   *    * * *   librenms    /opt/librenms/billing-calculate.php >> /dev/null 2>&1
*/5  *    * * *   librenms    /opt/librenms/check-services.php >> /dev/null 2>&1
* * * * * php /opt/librenms/artisan schedule:run