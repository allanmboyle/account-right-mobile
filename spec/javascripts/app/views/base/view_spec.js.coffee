describe("BaseView", () ->

  BaseView = null
  applicationState = null
  testableView = null

  jasmineRequire(this, [ "app/views/base/view", "app/models/application_state" ], (LoadedBaseView, ApplicationState) ->
    BaseView = LoadedBaseView
    applicationState = new ApplicationState()
  )

  describe("when subclassed", () ->

    TestableBaseView = null

    beforeEach(() ->
      class ABaseView extends BaseView
        initialize: (applicationState) ->
          super
          @someAttr = "Some Value"

      TestableBaseView = ABaseView
      testableView = new TestableBaseView(applicationState)
    )

    it("should allow a header to be rendered", () ->
      expect(testableView.renderHeader(title: { label: "Some Title" })).not.toBe("")
    )

    it("should establish the application state", () ->
      expect(testableView.applicationState).toBe(applicationState)
    )

    describe("#render", () ->

      filters = []

      beforeEach(() ->
        $("body").append("<div id='testable-base-view' data-role='page'></div>")

        class TestableBaseView extends BaseView

          el: $("#testable-base-view")

          renderOptions: { anOption: "some_option_value" }

          prepareDom: () ->
            @$el.html("Some Content")

        testableView = new TestableBaseView(applicationState)
      )

      afterEach(() ->
        $("#testable-base-view").remove()
      )

      describe("when no filters are provided", () ->

        it("should delegate to prepareDom to insert content in the DOM", () ->
          testableView.render()

          expect($("#testable-base-view")).toHaveText("Some Content")
        )

        it("should inform JQueryMobile to make the view the current page using renderOptions declared in the subclass", () ->
          spyOn($.mobile, "changePage")

          testableView.render()

          expectedRenderOptions =
            changeHash: false
            reverse: false
            allowSamePageTransition: true
            reloadPage: true
            anOption: "some_option_value"
          expect($.mobile.changePage).toHaveBeenCalledWith($("#testable-base-view"), expectedRenderOptions)
        )

        it("should make the page the active JQueryMobile page", () ->
          testableView.render()

          expect($.mobile.activePage).toBe($("#testable-base-view"))
        )

      )

      describe("when multiple filters are provided", () ->

        beforeEach(() ->
          filters = [ new StubFilter(), new StubFilter(), new StubFilter() ]
          testableView = new TestableBaseView(applicationState, filters)
        )

        describe("and all the filters return true", () ->

          beforeEach(() ->
            _.each(filters, (filter) -> spyOn(filter, "filter").andReturn(true))
          )

          it("should execute all filters providing the view as an argument", () ->
            testableView.render()

            _.each(filters, (filter) ->
                   expect(filter.filter).toHaveBeenCalledWith(testableView)
            )
          )

          it("should render the view", () ->
            testableView.render()

            expect($("#testable-base-view")).toHaveText("Some Content")
          )

        )

        describe("and a filter returns false", () ->

          beforeEach(() ->
            spyOn(filters[0], "filter").andReturn(true)
            spyOn(filters[1], "filter").andReturn(false)
            spyOn(filters[2], "filter").andReturn(true)
          )

          it("should not render the view", () ->
            testableView.render()

            expect($("#testable-base-view")).not.toHaveText("Some Content")
          )

          it("should not execute any filters after the filter that failed", () ->
            testableView.render()

            expect(filters[2].filter).not.toHaveBeenCalled
          )

        )

      )

      describe("when a filter is provided", () ->

        beforeEach(() ->
          filters = [ new StubFilter() ]
          testableView = new TestableBaseView(applicationState, filters)
        )

        describe("that returns true", () ->

          beforeEach(() ->
            spyOn(filters[0], "filter").andReturn(true)
          )

          it("should render the view", () ->
            testableView.render()

            expect($("#testable-base-view")).toHaveText("Some Content")
          )

        )

        describe("that returns false", () ->

          beforeEach(() ->
            spyOn(filters[0], "filter").andReturn(false)
          )

          it("should not render the view", () ->
            testableView.render()

            expect($("#testable-base-view")).not.toHaveText("Some Content")
          )

        )

      )

    )

    describe("#renderHeader", () ->

      options = null

      beforeEach(() ->
        class TestableBaseView extends BaseView

        testableView = new TestableBaseView(applicationState)

        options = { title: { label: "Some Title" } }
      )

      it("should render the title of the page", () ->
        headerElement = $(testableView.renderHeader(options))

        expect(headerElement.find("h1")).toHaveText("Some Title")
      )

      it("should render the site version watermark", () ->
        headerElement = $(testableView.renderHeader(options))

        expect(headerElement.find(".site-version")).toHaveText("Alpha")
      )

      describe("when an elementClass option" , () ->

        describe("is provided", () ->

          beforeEach(() ->
            options = _.extend(options, { elementClass: "some-class" })
          )

          it("should include the class in the outermost div's class attribute", () ->
            headerElement = $(testableView.renderHeader(options))

            expect(headerElement).toHaveAttr("class", "some-class")
          )

        )

        describe("is not provided", () ->

          it("should not have an class attribute in the outermost div", () ->
            headerElement = $(testableView.renderHeader(options))

            expect(headerElement.attr("class")).not.toBeDefined()
          )

        )

      )

      describe("when button options", () ->

        describe("are provided", () ->

          describe("containing a href and a label", () ->

            beforeEach(() ->
              options = _.extend(options, { button: { href: "#some_href", label: "Some Button Label" } })
            )

            it("should render a link representing the button whose a href and label matches those provided", () ->
              headerElement = $(testableView.renderHeader(options))

              link = headerElement.find("a")
              expect(link).toHaveAttr("href", "#some_href")
              expect(link).toHaveText("Some Button Label")
            )

            describe("and an elementId", () ->

              beforeEach(() ->
                options["button"]["elementId"] = "some-id"
              )

              it("should render a link containing the id", () ->
                headerElement = $(testableView.renderHeader(options))

                link = headerElement.find("a")
                expect(link).toHaveId("some-id")
              )

            )

          )

        )

        describe("are not provided", () ->

          it("should not render a button", () ->
            headerElement = $(testableView.renderHeader(options))

            expect(headerElement.find("a")).not.toExist()
          )

        )

      )

      describe("when a title elementClass option" , () ->

        describe("is provided", () ->

          beforeEach(() ->
            options["title"]["elementClass"] = "some-class"
          )

          it("should include the class in a h1 element containing the title", () ->
            headerElement = $(testableView.renderHeader(options))

            headingElement = headerElement.find("h1")
            expect(headingElement).toHaveText("Some Title")
            expect(headingElement).toHaveAttr("class", "some-class")
          )

        )

        describe("is not provided", () ->

          it("should not have an class attribute in the h1 element", () ->
            headerElement = $(testableView.renderHeader(options))

            headingElement = headerElement.find("h1")
            expect(headingElement.attr("class")).not.toBeDefined()
          )

        )

      )

    )

  )

)
