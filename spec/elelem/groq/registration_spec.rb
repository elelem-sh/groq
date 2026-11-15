# frozen_string_literal: true

RSpec.describe "the groq provider" do
  around do |example|
    saved = ENV.to_h.slice("GROQ_API_KEY", "GROQ_BASE_URL", "GROQ_MODEL")
    example.run
  ensure
    %w[GROQ_API_KEY GROQ_BASE_URL GROQ_MODEL].each { |k| ENV.delete(k) }
    ENV.update(saved)
  end

  before do
    ENV["GROQ_API_KEY"] = "test-key"
    ENV["GROQ_MODEL"] = "env-model"
    ENV.delete("GROQ_BASE_URL")
  end

  def build(**) = Elelem::Config.build_provider("groq", **)
  def uri(**) = build(**).instance_variable_get(:@uri).to_s
  def model(**) = build(**).instance_variable_get(:@model)

  it "registers provider groq" do
    expect(Elelem::Config.names).to include("groq")
    expect(build).to be_a(Elelem::OpenAI::Provider)
  end

  it "talks to Groq by default" do
    expect(uri).to eq("https://api.groq.com/openai/v1/chat/completions")
  end

  it "sends GROQ_API_KEY" do
    expect(build.instance_variable_get(:@api_key)).to eq("test-key")
  end

  it "names GROQ_API_KEY when the key is missing or empty" do
    ENV.delete("GROQ_API_KEY")
    expect { build }.to raise_error(KeyError, /GROQ_API_KEY/)

    ENV["GROQ_API_KEY"] = " "
    expect { build }.to raise_error(KeyError, /GROQ_API_KEY/)
  end

  it "names GROQ_MODEL when no model is set, and treats an empty one as unset" do
    ENV.delete("GROQ_MODEL")
    expect { build }.to raise_error(KeyError, /GROQ_MODEL/)

    ENV["GROQ_MODEL"] = ""
    expect { build }.to raise_error(KeyError, /GROQ_MODEL/)
  end

  it "takes the model from GROQ_MODEL" do
    expect(model).to eq("env-model")
  end

  it "prefers --model over GROQ_MODEL" do
    expect(model(model: "flag-model")).to eq("flag-model")
  end

  it "uses GROQ_BASE_URL, with or without a trailing slash, and treats an empty one as unset" do
    ENV["GROQ_BASE_URL"] = "http://127.0.0.1:8080/v1/"
    expect(uri).to eq("http://127.0.0.1:8080/v1/chat/completions")

    ENV["GROQ_BASE_URL"] = "http://127.0.0.1:8080/v1"
    expect(uri).to eq("http://127.0.0.1:8080/v1/chat/completions")

    ENV["GROQ_BASE_URL"] = ""
    expect(uri).to eq("https://api.groq.com/openai/v1/chat/completions")
  end
end
