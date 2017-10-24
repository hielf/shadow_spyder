require 'qiniu'
Qiniu.establish_connection! access_key: APP_CONFIG['qiniu_accesskey'],
                            secret_key: APP_CONFIG['qiniu_serect']
