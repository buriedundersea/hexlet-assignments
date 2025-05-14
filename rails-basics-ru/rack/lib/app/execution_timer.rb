# frozen_string_literal: true

class ExecutionTimer
  def initialize(app)
    @app = app
  end

  def call(env)
    Rack::Runtime.new(@app).call(env)
  end
end
