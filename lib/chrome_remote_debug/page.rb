require "json"
require "#{File.dirname(__FILE__)}/../../vendor/web-socket-ruby/lib/web_socket"


module ChromeRemoteDebug
  class Page
    def initialize(spec)
      @spec = spec
    end

    def url
      @spec["url"]
    end

    def favicon
      @spec["faviconUrl"]
    end

    def title
      @spec["title"]
    end

    def reload
      ws = ::WebSocket.new(@spec["webSocketDebuggerUrl"])
      ws.send(JSON.generate(Command.new("Page.reload")))
      ws.close()
    end

    def navigate(url)
      ws = ::WebSocket.new(@spec["webSocketDebuggerUrl"])
      ws.send(JSON.generate(Command.new("Page.navigate", :url => url)))
      ws.close()
    end

    def screenshot
      ws = ::WebSocket.new(@spec["webSocketDebuggerUrl"])
      ws.send(JSON.generate(Command.new("Page.captureScreenshot")))
      screenshot = JSON.parse(ws.receive, :symbolize_names => true)
      ws.close()

      screenshot
    end
  end
end
