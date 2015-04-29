class UniqueTokenGenerator
  def initialize(relation, column = :authentication_token)
    @relation = relation
    @column = column
  end

  def generate_token
    token = SecureRandom.uuid

    if relation.find_by(column => token)
      generate_token
    else
      token
    end
  end

  private

  attr_reader :relation, :column
end