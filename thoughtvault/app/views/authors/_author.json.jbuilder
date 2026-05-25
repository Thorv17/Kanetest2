json.extract! author, :id, :fname, :lname, :birth_yr, :death_yr, :bio, :created_at, :updated_at
json.url author_url(author, format: :json)
