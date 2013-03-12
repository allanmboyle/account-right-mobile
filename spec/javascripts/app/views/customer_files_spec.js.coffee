describe("CustomerFilesView", () ->

  CustomerFilesView = null
  CustomerFile = null

  jasmineRequire(this, [ "app/views/customer_files",
                         "app/models/customer_file",
                         "app/views/live_login" ], (LoadedCustomerFilesView, LoadedCustomerFile) ->
    CustomerFilesView = LoadedCustomerFilesView
    CustomerFile = LoadedCustomerFile
  )

  afterEach(() ->
    $("#customer_files").remove()
    $("#live_login").remove()
  )

  describe("when loaded", () ->

    it("should add a page placeholder to the dom", () ->
      expect($("#customer_files")).toExist()
    )

  )

  describe("when instantiated", () ->

    customerFilesView = null

    beforeEach(() ->
      customerFilesView = new CustomerFilesView()
    )

    it("should add customer file login content to the page which is initially hidden", () ->
      expect($("#customer-file-login-content")).toExist()
      expect($("#customer-file-login-content")).toBeHidden()
    )

    describe("and rendered", () ->

      describe("with multiple customer files", () ->

        beforeEach(() ->
          customerFilesView.customerFiles.add([new CustomerFile(name: "File 1"), new CustomerFile(name: "File 2")])

          customerFilesView.render()
        )

        it("should not show the login content within a customer file area", () ->
          expect($("#customer-file-login-content")).toBeHidden()
        )

        describe("and a customer file is clicked", () ->

          customerFileElement = null

          beforeEach(() ->
            customerFileElement = $($('.customer-file')[0])

            customerFileElement.find('a').click()
          )

          it("should show the login content within the clicked customer files area", () ->
            customerFileLoginToBeVisible = () ->
              customerFileElement.find("#customer-file-login-content").is(":visible")

            waitsFor(customerFileLoginToBeVisible, "Customer File Login content was hidden", 5000)
          )

          describe("and another customer file is clicked", () ->

            otherCustomerFileElement = null

            beforeEach(() ->
              otherCustomerFileElement = $($('.customer-file')[1])

              otherCustomerFileElement.find('a').click()
            )

            it("should show the login content within the most recently clicked customer files area", () ->
              customerFileLoginToBeVisible = () ->
                otherCustomerFileElement.find("#customer-file-login-content").is(":visible")

              waitsFor(customerFileLoginToBeVisible, "Customer File Login content was hidden", 5000)
            )

          )

          describe("and the login button is clicked", () ->

            it("should direct the user to the contacts page", () ->
              $("#customer_file_login_submit").click()

              expect(location.hash).toBe("#contacts")
            )

          )

        )

      )

      describe("with one customer file", () ->

        beforeEach(() ->
          customerFilesView.customerFiles.add([new CustomerFile(name: "File 1")])

          customerFilesView.render()
        )

        it("should show the login content within the customer file", () ->
          customerFileLoginToBeVisible = () ->
           otherCustomerFileElement.find(".customer-file #customer-file-login-content").is(":visible")

           waitsFor(customerFileLoginToBeVisible, "Customer File Login content was hidden", 5000)
        )

      )

    )

  )

)
