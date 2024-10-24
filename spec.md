# nixcon-2024 garnix game api spec

- `GET /` - returns a 200 status code
- `GET /add/{a}/{b}` - parses a and b as integers and returns `a + b` in the body
- `GET /mult/{a}/{b}` - parses a and b as integers and returns `a * b` in the body
- `GET /cowsay/{message}` - returns the output of `cowsay {message}` in the body
- `GET /uuid` - returns a random UUID in the body
