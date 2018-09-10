class WarSocketClient
    attr_reader :client
    attr_accessor :ready

    def initialize(client)
        @client = client
        @ready = false
    end

    def provide_input(text)
        @client.puts(text)
    end

    def capture_output(delay=0.1)
        sleep(delay)
        @output = @client.read_nonblock(1000)
    rescue IO::WaitReadable
        @output = ""
    end
end