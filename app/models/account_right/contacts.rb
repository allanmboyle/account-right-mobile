module AccountRight

  class Contacts

    def initialize
      @contacts = []
    end

    def concat(json_response, type)
      contacts_to_add = JSON.parse(json_response)["Items"]
      contacts_to_add.each { |contact| contact["Type"] = type }
      @contacts.concat(contacts_to_add)
      self
    end

    def to_json
      @contacts.to_json
    end

  end

end

