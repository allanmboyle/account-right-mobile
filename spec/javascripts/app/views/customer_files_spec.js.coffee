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
      loginFailSpy = null
      loginErrorSpy = null

      beforeEach(() ->
        initialActions["loginSuccess"] = CustomerFilesView.prototype.loginSuccess
        initialActions["loginFail"] = CustomerFilesView.prototype.loginFail
        initialActions["loginError"] = CustomerFilesView.prototype.loginError
        loginSuccessSpy = CustomerFilesView.prototype.loginSuccess = jasmine.createSpy()
        loginFailSpy = CustomerFilesView.prototype.loginFail = jasmine.createSpy()
        loginErrorSpy = CustomerFilesView.prototype.loginError = jasmine.createSpy()

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

      it("should trigger the loginFail action when the customer file user's login:fail event occurs", () ->
        customerFileUser.trigger("login:fail")

        expect(loginFailSpy).toHaveBeenCalled()
      )

      it("should trigger the loginError action when the customer file user's login:error event occurs", () ->
        customerFileUser.trigger("login:error")

        expect(loginErrorSpy).toHaveBeenCalled()
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

          it("should default the login forms username to 'Administrator'", () ->
            expect($("#customer-file-username")).toHaveValue("Administrator")
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
              $("#customer-file-login-submit").click()

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

      describe("the logout button", () ->

        beforeEach(() ->
          customerFilesView.render()
        )

        it("should redirect the user to the live login page", () ->
          expect($("#live-logout")).toHaveAttr("href", "#live_login")
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

          expect($("#customer-files-general-error-message-popup")).not.toHaveClass("ui-popup-active")
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

          generalErrorMessageToBeVisible = () ->
            $("#customer-files-general-error-message-popup").hasClass("ui-popup-active")

          waitsFor(generalErrorMessageToBeVisible, "general error message to be visible", 5000)
        )

      )

    )

    describe("#syncUser", () ->

      beforeEach(() ->
        $("#customer-file-username").val("some_user_name")
        $("#customer-file-password").val("some_password")
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

    describe("#loginFail", () ->

      beforeEach(() ->
        location.hash = "#customer_files"
      )

      it("should leave the user on the customer files page", () ->
        customerFilesView.loginFail()

        expect(location.hash).toMatch(/^#customer_files/)
      )

      it("should make the login failure popup visible", () ->
        customerFilesView.loginFail()

        expect($("#customer-file-login-fail-message-popup")).toHaveClass("ui-popup-active")
      )

      it("should display a popup with a message indicating the login attempt failed", () ->
        customerFilesView.loginFail()

        expect($("#customer-file-login-fail-message")).toHaveText("The username or password you entered is incorrect")
      )

    )

    describe("#loginError", () ->

      beforeEach(() ->
        location.hash = "#customer_files"
      )

      it("should leave the user on the customer files page", () ->
        customerFilesView.loginError()

        expect(location.hash).toMatch(/^#customer_files/)
      )

      it("should make the login error popup visible", () ->
        customerFilesView.loginError()

        expect($("#customer-file-login-error-message-popup")).toHaveClass("ui-popup-active")
      )

      it("should display a popup with a message indicating an error occurred during the login attempt", () ->
        customerFilesView.loginError()

        expect($("#customer-file-login-error-message")).toHaveText("We can't confirm your details at the moment, try again shortly")
      )

    )

  )

)
