class FindOrCreateUser < Struct.new(:auth_hash)
  def call
    User.find_or_create_by!(attrs)
  end

  private

    def attrs
      {
        sso_id: auth_hash['uid'],
        name: auth_hash['name'],
        email: auth_hash['email']
      }
    end
end
