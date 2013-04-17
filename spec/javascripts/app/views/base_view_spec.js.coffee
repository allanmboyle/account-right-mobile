describe("BaseView", () ->

  BaseView = null
  testableView = null

  jasmineRequire(this, [ "app/views/base_view" ], (LoadedBaseView) ->
    BaseView = LoadedBaseView
  )

  describe("when subclassed", () ->

    beforeEach(() ->
      class TestableBaseView extends BaseView
        initialize: () ->
          @someAttr = "Some Value"

      testableView = new TestableBaseView()
    )

    it("should allow a header to be rendered", () ->
      expect(testableView.renderHeader(title: { label: "Some Title" })).not.toBe("")
    )

    describe("#render", () ->

      beforeEach(() ->
        $("body").append("<div id='testable-base-view' data-role='page'></div>")
        class TestableBaseView extends BaseView

          el: $("#testable-base-view")

          renderOptions: { anOption: "some_option_value" }

          prepareDom: () ->
            @$el.html("Some Content")

        testableView = new TestableBaseView()
      )

      afterEach(() ->
        $("#testable-base-view").remove()
      )

      it("should destroy any previously rendered page", () ->
        pageMethodSpy = spyOn(testableView.$el, "page").andReturn(testableView.$el)

        testableView.render()

        expect(pageMethodSpy).toHaveBeenCalledWith("destroy")
      )

      it("should delegate to prepareDom to insert content in the DOM", () ->
        testableView.render()

        expect($("#testable-base-view")).toHaveText("Some Content")
      )

      it("should inform JQueryMobile to make the view the current page using renderOptions declared in the subclass", () ->
        spyOn($.mobile, "changePage")

        testableView.render()

        expect($.mobile.changePage).toHaveBeenCalledWith(
          "#testable-base-view", { reverse: false, changeHash: false, anOption: "some_option_value" }
        )
      )

      it("should make the page the active JQueryMobile page", () ->
        testableView.render()

        expect($.mobile.activePage).toHaveAttr("id", "testable-base-view")
      )

    )

    describe("#renderHeader", () ->

      options = null

      beforeEach(() ->
        class TestableBaseView extends BaseView
        testableView = new TestableBaseView()

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
