class FindOrCreateUser < Struct.new(:auth_hash)
  def call
    User.find_or_initialize_by!(sso_id: attrs[:sso_id]).tap do |user|
      user.update_attributes!(attrs)
    end
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
