"""
Spawn a websocket that handles forking of shell sessions for attachment by the bertdotbill WebTerminal UI element. 
The code for this was taken from [spyder-terminal](https://github.com/spyder-ide/spyder-terminal).
"""

from webterminal import WebTerminal

def main():
  """The main entrypoint
  """    

  webterminal_listen_host  = '0.0.0.0'
  webterminal_listen_port = 10001
  WebTerminal().start(host=webterminal_listen_host , port=webterminal_listen_port)
                
if __name__ == '__main__':
  main()


