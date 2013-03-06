describe("CustomerFilesView", () ->

  CustomerFilesView = null
  CustomerFile = null

  jasmineRequire(this, [ "app/views/customer_files",
                         "app/models/customer_file",
                         "app/views/live_login" ], (LoadedCustomerFilesView, LoadedCustomerFile) ->
    CustomerFilesView = LoadedCustomerFilesView
    CustomerFile = LoadedCustomerFile
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

    afterEach(() ->
      $("#customer_files").html("")
    )

    it("should add customer file login content to the page which is initially hidden", () ->
      expect($("#customer-file-login-content")).toExist()
      expect($("#customer-file-login-content")).toBeHidden()
    )

    describe("and rendered", () ->

      beforeEach(() ->
        customerFilesView.customerFiles.add([new CustomerFile(name: "File 1"), new CustomerFile(name: "File 2")])

        customerFilesView.render()
      )

      afterEach(() ->
        $.mobile.changePage("#live_login", reverse: false, changeHash: false)
      )

      describe("and a customer file is clicked", () ->

        customerFileElement = null

        beforeEach(() ->
          customerFileElement = $($('.customer-file')[0])
          
          customerFileElement.find('a').click()
        )

        it("should show the login content within the clicked customer files area", () ->
          expect(customerFileElement.find("#customer-file-login-content")).toExist()
          expect(customerFileElement.find("#customer-file-login-content")).toBeVisible()
        )
        
        describe("and another customer file is clicked", () ->

          otherCustomerFileElement = null

          beforeEach(() ->
            otherCustomerFileElement = $($('.customer-file')[1])

            otherCustomerFileElement.find('a').click()
          )

          it("should show the login content within the most recently clicked customer files area", () ->
            expect(otherCustomerFileElement.find("#customer-file-login-content")).toExist()
            expect(otherCustomerFileElement.find("#customer-file-login-content")).toBeVisible()
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

  )

)
