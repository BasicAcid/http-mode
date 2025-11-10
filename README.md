# http-mode.el

An Emacs minor mode for syntax highlighting of plaintext HTTP requests and responses.

## Features

- Syntax highlighting for HTTP methods (GET, POST, PUT, DELETE, etc.)
- Highlights URIs in request lines
- Highlights HTTP versions (HTTP/1.1, HTTP/2, etc.)
- Highlights status codes and status text in responses
- Highlights header names and values
- Automatically enabled for `.http` and `.rest` files

## Installation

### Using straight.el

```elisp
(use-package http-mode
  :straight (:host github :repo "BasicAcid/http-mode"))
```

Or if you prefer manual straight installation:

```elisp
(straight-use-package
 '(http-mode :type git :host github :repo "BasicAcid/http-mode"))
```

### Manual Installation

1. Download `http-mode.el` to your Emacs load path
2. Add to your init file:

```elisp
(require 'http-mode)
```

## Usage

The mode automatically activates when you open `.http` or `.rest` files.

You can also manually enable it in any buffer:

```
M-x http-mode
```

## Examples

### GET Request

```http
GET / HTTP/1.1
Host: example.com
User-Agent: htreq/1.0
Accept: */*
Connection: close

```

### POST Request

```http
POST /post HTTP/1.1
Host: postman-echo.com
Content-Type: application/json
Content-Length: 17
Connection: close

{"test": "value"}
```

### HTTP Response

```http
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 42

{"status": "success", "message": "Hello!"}
```
