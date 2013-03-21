describe("CustomerFilesView", () ->

  CustomerFilesView = null
  CustomerFile = null
  CustomerFileUser = null

  jasmineRequire(this, [ "app/views/customer_files",
                         "app/models/customer_file",
                         "app/models/customer_file_user" ], (LoadedCustomerFilesView, LoadedCustomerFile,
                                                             LoadedCustomerFileUser) ->
    CustomerFilesView = LoadedCustomerFilesView
    CustomerFile = LoadedCustomerFile
    CustomerFileUser = LoadedCustomerFileUser
  )

  beforeEach(() ->
    # Compensation for pageshow not being triggered in behaviours
    $("#customer_files").on("pagebeforeshow", () -> $("#customer_files").trigger("pageshow"))
  )

  afterEach(() ->
    $("#customer_files").remove()
  )

  describe("when loaded", () ->

    it("should add a page placeholder to the dom", () ->
      expect($("#customer_files")).toExist()
    )

  )

  describe("when instantiated", () ->

    customerFilesView = null
    customerFiles = null
    customerFileUser = null

    beforeEach(() ->
      customerFilesView = new CustomerFilesView()
      customerFiles = customerFilesView.customerFiles
      customerFileUser = customerFilesView.customerFileUser
    )

    it("should add customer file login content to the page which is initially hidden", () ->
      expect($("#customer-file-login-content")).toExist()
      expect($("#customer-file-login-content")).toBeHidden()
    )

    describe("model event configuration", () ->

      initialActions = {}
      loginSuccessSpy = null

      beforeEach(() ->
        initialActions["loginSuccess"] = CustomerFilesView.prototype.loginSuccess
        loginSuccessSpy = CustomerFilesView.prototype.loginSuccess = jasmine.createSpy()

        customerFilesView = new CustomerFilesView()
        customerFileUser = customerFilesView.customerFileUser
      )

      afterEach(() ->
        _.extend(CustomerFilesView.prototype, initialActions)
      )

      it("should trigger the loginSuccess action when the customer file user's login:success event occurs", () ->
        customerFileUser.trigger("login:success")

        expect(loginSuccessSpy).toHaveBeenCalled()
      )

    )

    describe("and rendered", () ->

      describe("with multiple customer files", () ->

        beforeEach(() ->
          customerFiles.add([new CustomerFile(Name: "File 1"), new CustomerFile(Name: "File 2"), new CustomerFile(Name: "File 3")])

          customerFilesView.render()
        )

        it("should not show the login content within a customer file area", () ->
          expect($("#customer-file-login-content")).toBeHidden()
        )

        it("should not show a message indicating no files are available", () ->
           customerFilesAvailableMessageToBeHidden = () -> $("#no-customer-files-message").is(":hidden")

           waitsFor(customerFilesAvailableMessageToBeHidden, "Customer Files available message to be hidden", 5000)
        )

        describe("and a customer file is expanded", () ->

          customerFileElement = null

          beforeEach(() ->
            customerFileElement = $($('.customer-file')[0])

            customerFileElement.find('a').click()
          )

          it("should show the login content within the clicked customer files area", () ->
            customerFileLoginToBeVisible = () ->
              customerFileElement.find("#customer-file-login-content").is(":visible")

            waitsFor(customerFileLoginToBeVisible, "Customer File Login content to be visible", 5000)
          )

          it("should update the expanded file in the customer files model", () ->
            expandedFileToBeUpdatedInModel = () -> customerFiles.expandedPosition == 0

            waitsFor(expandedFileToBeUpdatedInModel, "File model to be marked as expanded", 5000)
          )

          describe("and another customer file is expanded", () ->

            otherCustomerFileElement = null

            beforeEach(() ->
              otherCustomerFileElement = $($('.customer-file')[1])

              otherCustomerFileElement.find('a').click()
            )

            it("should show the login content within the most recently clicked customer files area", () ->
              customerFileLoginToBeVisible = () ->
                otherCustomerFileElement.find("#customer-file-login-content").is(":visible")

              waitsFor(customerFileLoginToBeVisible, "Customer File Login content to be visible", 5000)
            )

          )

          describe("and the login button is clicked", () ->

            beforeEach(() ->
              spyOn(customerFilesView, "login")

              customerFilesView.delegateEvents() # Attach spy to DOM events
            )

            it("should trigger the login action", () ->
              $("#customer_file_login_submit").click()

              loginActionHasBeenCalled = () -> customerFilesView.login.callCount == 1
              waitsFor(loginActionHasBeenCalled, "login action to be called", 5000)
            )

          )

        )

      )

      describe("with one customer file", () ->

        beforeEach(() ->
          customerFiles.add(new CustomerFile(Name: "File 1"))

          customerFilesView.render()
        )

        it("should show the login content within the customer file", () ->
          customerFileLoginToBeVisible = () ->
            $(".customer-file #customer-file-login-content").is(":visible")

          waitsFor(customerFileLoginToBeVisible, "Customer File Login content to be visible", 5000)
        )

        it("should not show a message indicating no files are available", () ->
          customerFilesAvailableMessageToBeHidden = () -> $("#no-customer-files-message").is(":hidden")

          waitsFor(customerFilesAvailableMessageToBeHidden, "Customer Files available message to be hidden", 5000)
        )

      )

      describe("with no customer files", () ->

        beforeEach(() ->
          customerFilesView.render()
        )

        it("should show a message indicating no files are available", () ->
          noCustomerFilesAvailableMessageToBeVisible = () -> $("#no-customer-files-message").is(":visible")

          waitsFor(noCustomerFilesAvailableMessageToBeVisible, "Customer Files available message to be visible", 5000)
        )

      )

    )

    describe("#update", () ->

      describe("when customer files are successfully fetched", () ->

        beforeEach(() ->
          spyOn(Backbone, "ajax").andCallFake((options) -> options.success([{ Name: "File Name" }]))
        )

        it("should render the view", () ->
          spyOn(customerFilesView, "render")

          customerFilesView.update()

          renderToBeCalled = () -> customerFilesView.render.callCount == 1
          waitsFor(renderToBeCalled, "update action to eventually trigger render", 5000)
        )

        it("should not show a message indicating an error occurred", () ->
          customerFilesView.update()

          expect($("#general_error_message-popup")).not.toHaveClass("ui-popup-active")
        )

      )

      describe("when an error occurs fetching the customer files", () ->

        beforeEach(() ->
          spyOn(Backbone, "ajax").andCallFake((options) -> options.error())
        )

        it("should render the view", () ->
          spyOn(customerFilesView, "render")

          customerFilesView.update()

          renderToBeCalled = () -> customerFilesView.render.callCount == 1
          waitsFor(renderToBeCalled, "update action to eventually trigger render", 5000)
        )

        it("should show a message indicating an error occurred", () ->
          customerFilesView.update()

          generalErrorMessageToBeVisible = () -> $("#general_error_message-popup").hasClass("ui-popup-active")

          waitsFor(generalErrorMessageToBeVisible, "general error messages to be visible", 5000)
        )

      )

    )

    describe("#syncUser", () ->

      beforeEach(() ->
        $("#customer_file_username").val("some_user_name")
        $("#customer_file_password").val("some_password")
      )

      it("should update the user with the form field values", () ->
        customerFilesView.syncUser()

        expect(customerFileUser.get("username")).toBe("some_user_name")
        expect(customerFileUser.get("password")).toBe("some_password")
      )

    )

    describe("#login", () ->

      event = null

      beforeEach(() ->
        event = new StubEvent()

        spyOn(customerFilesView, "syncUser")
        spyOn(customerFilesView.customerFiles, "login")
      )

      it("should update the user model to include the entered credentials", () ->
        customerFilesView.login(event)

        expect(customerFilesView.syncUser).toHaveBeenCalled()
      )

      it("should login the user via the model", () ->
        customerFilesView.login(event)

        expect(customerFiles.login).toHaveBeenCalledWith(customerFileUser)
      )

      it("should prevent propogation of the event", () ->
        spyOn(event, "preventDefault")

        customerFilesView.login(event)

        expect(event.preventDefault).toHaveBeenCalled()
      )

    )

    describe("#loginSuccess", () ->

      beforeEach(() ->
        location.hash = ""
      )

      it("should navigate the user to the contacts page", () ->
        customerFilesView.loginSuccess({})

        expect(location.hash).toBe("#contacts")
      )

    )

  )

)
