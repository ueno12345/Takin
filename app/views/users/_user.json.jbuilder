json.extract! user, :id, :account_name, :password, :admin_flag, :created_at, :updated_at
json.url user_url(user, format: :json)
