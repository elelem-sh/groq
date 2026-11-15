# elelem-groq

A [Groq](https://console.groq.com/keys) provider plugin for [elelem](https://elelem.sh).
It talks to Groq's OpenAI-compatible Chat Completions API
through [elelem-openai](https://github.com/elelem-sh/openai).

## Install

```sh
gem install elelem-groq
```

## Use

```sh
export GROQ_API_KEY=...
elelem -p groq --model MODEL
```

* `GROQ_API_KEY` (required): get one at https://console.groq.com/keys
* `GROQ_MODEL`: the model, when `--model` is not given
* `GROQ_BASE_URL`: overrides `https://api.groq.com/openai/v1`

There is no default model, since free model lists change often. With
no model set, elelem stops and names `GROQ_MODEL`. A variable that is
set but empty counts as unset.

Free tier limits are on Groq's own page: https://console.groq.com/docs/rate-limits

## Development

```sh
bin/setup
bin/test
bin/lint
```

## License

MIT. See LICENSE.txt.
