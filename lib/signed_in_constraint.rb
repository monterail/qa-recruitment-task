class SignedInConstraint
  def matches?(request)
    request.env["warden"].authenticate?
  end
end
