class StubSession < Hash

  def update(hash)
    self.merge!(hash)
  end

end
