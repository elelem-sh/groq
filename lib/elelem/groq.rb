# frozen_string_literal: true

require "elelem/openai"

require_relative "groq/version"

Elelem.configure do |config|
  config.provider(:groq) do |model: nil, **|
    # A variable that is set but empty counts as unset.
    env = ->(name) { ENV[name].to_s.strip.then { |v| v.empty? ? nil : v } }
    key = env.call("GROQ_API_KEY")
    raise KeyError, "GROQ_API_KEY is not set" if key.nil?

    model = env.call("GROQ_MODEL") if model.to_s.strip.empty?
    raise KeyError, "GROQ_MODEL is not set. Pass --model or set GROQ_MODEL" if model.nil?

    Elelem::OpenAI::Provider.new(
      model:,
      api_key: key,
      base_url: env.call("GROQ_BASE_URL") || "https://api.groq.com/openai/v1"
    )
  end
end
