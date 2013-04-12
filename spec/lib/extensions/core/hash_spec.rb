describe Extensions::Core::Hash do

  describe "#nested_merge" do

    describe "when the hashes are multiple levels deep" do

      let(:original_hash) do
        { key1: { key1_1: { key1_1_1: "value1_1_1", key1_1_2: "value1_1_2", key1_1_3: "value1_1_3" },
                  key1_2: { key1_2_1: "value1_2_1", key1_2_2: "value1_2_2", key1_2_3: "value1_2_3" },
                  key1_3: { key1_3_1: "value1_3_1", key1_3_2: "value1_3_2", key1_3_3: "value1_3_3" } } }
      end

      let(:new_hash) do
        { key1: { key1_1: { key1_1_2: "another_value1_1_2", key1_1_x: "value1_1_x" },
                  key1_2: "value1_2",
                  key1_x: { key1_x_1: "value1_x_1", key1_x_2: "value1_x_2", key1_x_3: "value1_x_3" } } }
      end

      it "should retain values which are not overridden" do
        result = original_hash.nested_merge(new_hash)

        result[:key1].should include(key1_3: { key1_3_1: "value1_3_1", key1_3_2: "value1_3_2", key1_3_3: "value1_3_3" })
        result[:key1][:key1_1].should include(key1_1_1: "value1_1_1")
      end

      it "should override values which are to be overridden" do
        result = original_hash.nested_merge(new_hash)

        result[:key1][:key1_1].should include(key1_1_2: "another_value1_1_2")
        result[:key1].should include(key1_2: "value1_2")
      end

      it "should add values not present in the original hash" do
        result = original_hash.nested_merge(new_hash)

        result[:key1][:key1_1].should include(key1_1_x: "value1_1_x")
        result[:key1].should include(key1_x: { key1_x_1: "value1_x_1", key1_x_2: "value1_x_2", key1_x_3: "value1_x_3" })
      end

    end

    describe "when the hashes are one level deep" do

      let(:original_hash) do
        { key1: "value1", key2: "value2", key3: "value3" }
      end

      let(:new_hash) do
        { key1: "another_value1", key2: "value2", keyx: "valuex" }
      end

      it "should retain values which are not overridden" do
        result = original_hash.nested_merge(new_hash)

        result.should include(key3: "value3")
      end

      it "should override values which are to be overridden" do
        result = original_hash.nested_merge(new_hash)

        result.should include(key1: "another_value1")
      end

      it "should add values not present in the original hash" do
        result = original_hash.nested_merge(new_hash)

        result.should include(keyx: "valuex")
      end

    end

    describe "merging nil values" do

      describe "when the hashes are shallow" do

        it "should override a destination value with nil when the source value is nil" do
          result = { key: "value" }.nested_merge({ key: nil })

          result[:key].should be_nil
        end

      end

      describe "when the hashes are deep" do

        it "should override a destination value with nil when the source value is nil" do
          result = { key1: { key2: "value"} }.nested_merge({ key1: { key2: nil } })

          result[:key1][:key2].should be_nil
        end

      end

    end

  end

end
