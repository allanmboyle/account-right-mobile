describe("CustomerFilesView", () ->

  CustomerFilesView = null
  LiveLoginRequiredFilter = null
  CustomerFile = null
  CustomerFileUser = null
  applicationState = null

  jasmineRequire(this, [ "app/views/customer_files",
                         "app/views/filters/live_login_required",
                         "app/models/customer_file",
                         "app/models/customer_file_user",
                         "app/models/application_state" ], (LoadedCustomerFilesView, LoadedLiveLoginRequiredFilter,
                                                            LoadedCustomerFile, LoadedCustomerFileUser,
                                                            ApplicationState) ->
    CustomerFilesView = LoadedCustomerFilesView
    LiveLoginRequiredFilter = LoadedLiveLoginRequiredFilter
    CustomerFile = LoadedCustomerFile
    CustomerFileUser = LoadedCustomerFileUser
    applicationState = new ApplicationState()
    spyOn(applicationState, "isLoggedInToLive").andReturn(true)
  )

  beforeEach(() ->
    # Compensation for pageshow not being triggered in behaviours
    $("#customer-files").on("pagebeforeshow", () -> $("#customer-files").trigger("pageshow"))
  )

  afterEach(() ->
    $("#customer-files").remove()
  )

  describe("when loaded", () ->

    it("should add a page placeholder to the dom", () ->
      expect($("#customer-files")).toExist()
    )

  )

  describe("when instantiated", () ->

    initialPrototype = null
    customerFilesView = null
    customerFiles = null
    customerFileUser = null

    beforeEach(() ->
      initialPrototype = _.extend({}, CustomerFilesView.prototype)

      establishView()
    )

    afterEach(() ->
      CustomerFilesView.prototype = initialPrototype
    )

    it("should require the user to be logged-in to AccountRight Live", () ->
      expect(new CustomerFilesView(applicationState).filters[0] instanceof LiveLoginRequiredFilter).toBeTruthy()
    )

    describe("model event configuration", () ->

      loginSuccessSpy = null
      loginFailSpy = null
      loginErrorSpy = null

      beforeEach(() ->
        loginSuccessSpy = CustomerFilesView.prototype.loginSuccess = jasmine.createSpy()
        loginFailSpy = CustomerFilesView.prototype.loginFail = jasmine.createSpy()
        loginErrorSpy = CustomerFilesView.prototype.loginError = jasmine.createSpy()

        establishView()
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

    describe("#render", () ->

      it("should render a logout button that redirects the user to the live login page", () ->
        customerFilesView.render()

        expect($("#live-logout")).toHaveAttr("href", "#live_login")
      )

      it("should insert login content to the page that is initially hidden", () ->
        customerFilesView.render()

        expect($("#customer-file-login-content")).toExist()
        expect($("#customer-file-login-content")).toBeHidden()
      )

      describe("with multiple customer files", () ->

        beforeEach(() ->
          customerFiles.add([new CustomerFile(Name: "File 1"),
                             new CustomerFile(Name: "File 2"),
                             new CustomerFile(Name: "File 3")])

          customerFilesView.render()
        )

        it("should not show the login content within a customer file area", () ->
          expect($("#customer-file-login-content")).toBeHidden()
        )

        it("should not show a message indicating no files are available", () ->
           noFilesAvailableMessageToBeHidden = () -> $("#no-customer-files-message").is(":hidden")

           waitsFor(noFilesAvailableMessageToBeHidden, "No Customer Files available message to be hidden", 5000)
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

            it("should trigger the login action", () ->
              spyOn(customerFilesView, "login")
              customerFilesView.delegateEvents() # Attach spy to DOM events

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
          noFilesAvailableMessageToBeHidden = () -> $("#no-customer-files-message").is(":hidden")

          waitsFor(noFilesAvailableMessageToBeHidden, "No Customer Files available message to be hidden", 5000)
        )

      )

      describe("with no customer files", () ->

        beforeEach(() ->
          customerFilesView.render()
        )

        it("should show a message indicating no files are available", () ->
          noFilesAvailableMessageToBeVisible = () -> $("#no-customer-files-message").is(":visible")

          waitsFor(noFilesAvailableMessageToBeVisible, "No Customer Files available message to be visible", 5000)
        )

      )

    )

    describe("#update", () ->

      describe("when customer files are successfully fetched", () ->

        beforeEach(() ->
          spyOn(Backbone, "ajax").andCallFake((options) -> options.success([{ Name: "File Name" }]))
        )

        it("should render the view", () ->
          renderSpy = CustomerFilesView.prototype.render = jasmine.createSpy()
          establishView()

          customerFilesView.update()

          renderToBeCalled = () -> renderSpy.callCount == 1
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
          renderSpy = CustomerFilesView.prototype.render = jasmine.createSpy()
          establishView()

          customerFilesView.update()

          renderToBeCalled = () -> renderSpy.callCount == 1
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

    describe("and rendered", () ->

      beforeEach(() ->
        customerFilesView.render()
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

        customerFile = null

        beforeEach(() ->
          customerFile = new CustomerFile(Name: "Some File")

          location.hash = ""
        )

        it("should establish the customer file the user has logged-in to in the application state", () ->
          customerFilesView.loginSuccess(customerFile)

          expect(applicationState.openedCustomerFile).toBe(customerFile)
        )

        it("should navigate the user to the contacts page", () ->
          customerFilesView.loginSuccess(customerFile)

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

    establishView = () ->
      customerFilesView = new CustomerFilesView(applicationState)
      customerFilesView.filters = []
      customerFiles = customerFilesView.customerFiles
      customerFileUser = customerFilesView.customerFileUser

  )

)
