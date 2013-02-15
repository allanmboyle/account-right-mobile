describe("A specification with a asynchronous beforeEach", () ->

  Contact = null
  contact = null

  specRequire(this, [ "app/models/contact" ], (LoadedContact) -> Contact = LoadedContact)

  beforeEach(() ->
    contact = new Contact()
  )

  it("should execute the asynchronous beforeEach before any behaviors are evaluated", () ->
    expect(Contact).not.toBeNull()
  )

  it("should execute a subsequent non-asynchronous beforeEach after the asychronous beforeEach is evaluated", () ->
    expect(contact).not.toBeNull()
  )

  describe("and a nested describe", () ->

    nested_contact = null

    beforeEach(() ->
      nested_contact = new Contact()
    )

    it("should execute a non-ayschronous nested beforeEach after the initial before each", () ->
      expect(nested_contact).not.toBeNull()
    )

  )

)
