class Actor
  include Neo4j::ActiveNode

  property :name
  property :age, type: Integer

  # has_many :out, :friends, type: :friends_with, model_name: 'User'
  # has_one :in,   :github_profile, type: :linked_to  # model_name: 'GithubProfile' assumed
end
