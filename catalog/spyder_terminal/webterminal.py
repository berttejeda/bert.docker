import tornado.web
import tornado.ioloop
from bertdotbill.spyder_terminal.server.common import create_app

from logger import Logger
logger = Logger().init_logger(__name__)

class WebTerminal:

    def __init__(self):
      pass

    def start(self, host, port):
        clr = 'cls'
        webterminal_shell_name = 'bash'
        logger.info(f'Server is now at: {host}:{port}')
        logger.info(f'Shell: {webterminal_shell_name}')
        application = create_app('/bin/bash',
                                 debug=False,
                                 serve_traceback=None,
                                 autoreload=None)
        ioloop = tornado.ioloop.IOLoop.instance()
        application.listen(port, address=host)
        try:
            ioloop.start()
        except KeyboardInterrupt:
            pass
        finally:
            logger.info("Closing server...\n")
            application.term_manager.shutdown()
            tornado.ioloop.IOLoop.instance().stop()

