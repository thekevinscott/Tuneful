MongoMapper.connection = Mongo::Connection.new('db.mongohq.com', 
27017, :auto_reconnect => true) 

MongoMapper.database = "tuneful_#{Rails.env}"

MongoMapper.database.authenticate('thekevinscott', 'tuneful1Fp3v')