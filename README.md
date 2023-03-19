A tiny wrapper around the openai python api that lets you pipe text via stdin into chatgpt.

```bash
export OPENAI_API_KEY=<insert_your_api_key_here>

echo "What is gpt? (one short sentence)" | nix run github:seb314/gpt-cli
```

Output:

```
GPT (Generative Pre-trained Transformer) is an advanced language model that uses machine learning to generate human-like text based on given input.
```
