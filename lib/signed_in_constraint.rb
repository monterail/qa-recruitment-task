class SignedInConstraint
  def matches?(request)
    return false unless request.env["warden"].authenticate?
    true
  end
end
