# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tuneful_session',
  :secret      => 'ca59364a3834db89e83f62d3bd721f22223cd2c2e40888bc537a02a35799bf810c8d5ec434f328f1928c88db820d6a56fb2db13982742dfb2d88925cddebaeb5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
