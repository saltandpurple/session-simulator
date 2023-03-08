from http.server import BaseHTTPRequestHandler, HTTPServer
from http import cookies
import socket
import random

# todo: get /activesessions that returns (mock) number of active sessions
# todo: post /activesessions that sets the (mock) number of active sessions

class Server(BaseHTTPRequestHandler):
    def _set_response(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        if not self.headers.get('Cookie'):
            self.send_header('Set-Cookie', "Affinity={}".format(socket.gethostname()))
        self.end_headers()

    def do_GET(self):
        self._set_response()
        if self.path == "/":
            self.wfile.write("You're on machine: {}\n Your cookies: {}".format(socket.gethostname(), self.headers.get('Cookie')).encode('utf-8'))

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)  # <--- Gets the data itself

        self._set_response()
        self.wfile.write("POST request for {}".format(self.path).encode('utf-8'))


def run(server_class=HTTPServer, handler_class=Server, port=8080):
    server_address = ('', port)
    webserver = server_class(server_address, handler_class)
    try:
        webserver.serve_forever()
    except KeyboardInterrupt:
        pass
    webserver.server_close()


if __name__ == '__main__':
    from sys import argv

    if len(argv) == 2:
        run(port=int(argv[1]))
    else:
        run()
