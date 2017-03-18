./solr-5.5.2/bin/solr start
source /usr/local/rvm/scripts/rvm
rvm use ruby-2.2.0
./solr-5.5.2/bin/solr create_core -c blacklight-core -d florentine-drawings-solr-config/conf/
cd florentine-drawings
rake db:migrate RAILS_ENV=development
rake itatti:index
rails s -b 0.0.0.0 -p 80