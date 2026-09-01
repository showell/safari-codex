#!/usr/bin/env python3
"""Serve web/ for an eye test.

    ./harness/serve.py [port]        # default 9200

NO-STORE ON EVERYTHING, which is the whole reason this is not one line of
`python3 -m http.server`. A blitter.js or a safari.wasm cached by the browser
looks exactly like a build that did not change anything, and the only way to tell
is to remember to hard-reload -- which is a footgun aimed at the one activity this
server exists for. The wasm is the worse half: WebAssembly.instantiateStreaming
goes through the HTTP cache like any other fetch, so a rebuilt module can be
invisible.

web/ is the document root because blitter.js fetches an ABSOLUTE
/driving/safari.wasm -- the path the real game serves it from.
"""

import functools
import http.server
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent / 'web'


class Handler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-store, must-revalidate')
        super().end_headers()


def main():
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 9200
    handler = functools.partial(Handler, directory=str(ROOT))
    # 0.0.0.0: the box is where the build is, and the eyes are somewhere else.
    with http.server.ThreadingHTTPServer(('0.0.0.0', port), handler) as httpd:
        print(f'serving {ROOT} on http://0.0.0.0:{port}  (no-store)', flush=True)
        httpd.serve_forever()


if __name__ == '__main__':
    main()
