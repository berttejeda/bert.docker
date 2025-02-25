# Overview

This repo contains the docker artifacts for building a containerized 
instance of a websocket attached to a bash process.
I am using this in the WebTerminal/[xtermjs](https://xtermjs.org/) component for [bert.bill](https://github.com/berttejeda/bert.bill)

# Under the hood

- Entrypoint for the image is [entrypoint.sh](entrypoint.sh)
- The script above launches [app.py](app.py), which starts a websocket on port 10001 and spawns a new bash process<br />
  whenever a request is made to the /terminals endpoint
- You can utilize [xtermjs](https://xtermjs.org/) to connect to this websocket and interact with the bash process via your web browser<br />
  but you'll have to implement the right API calls to get the ID for the new terminal session ... haven't documented that yet

# Building the image

`docker build -t <yourImageTag> .`

# Usage

Here's how to launch the websocket and map the container's default listening port (10001) to 
the corresponding docker host port: `docker run -d -p 10001:10001 <yourImageTag>`

You can also launch the pre-built image from dockerhub: `docker run -d -p 10001:10001 berttejeda/bill-webterminal`

# Credits

I knabbed the python code from [spyder-terminal](https://github.com/spyder-ide/spyder-terminal) and made adjustments to my needs.