module Aladtec
  class Authentication
    attr_accessor :code, :retry, :message, :member

    def initialize(args = {})
      @code = args["code"].to_i
      @retry = args["retry"]
      @message = args["message"]
      @member = args["member"]
    end

    def success?
      self.code == 0
    end
  end
end
