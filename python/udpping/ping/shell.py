#!/usr/bin/python
# -*- coding: utf-8 -*-

# udpping [-hv] [-s size] [-x proxy] [-c count] -t [timeout] host port

import logging
import getopt
import sys

from functools import wraps

from ping.common import to_str

verbose = 0

def print_help():
    print('''usages: udpping [-hv] [-s size] [-x proxy] [-c count] -t [timeout ms] -i [interval ms] host port''')

def print_exception(e):
    global verbose
    logging.error(e)
    if verbose > 0:
        import traceback
        traceback.print_exc()

def exception_handle(self_, err_msg=None, exit_code=None,
                    destroy=False, conn_err=False):
    # self_: if function passes self as first arg
    
    def process_exception(e, self=None):
        print_exception(e)
        if err_msg:
            logging.error(err_msg)
        if exit_code:
            sys.exit(1)
        if not self_:
            return
    
    def decorator(func):
        if self_:
            @wraps(func)
            def wrapper(self, *args, **kwargs):
                try:
                    func(self, *args, **kwargs)
                except Exception as e:
                    process_exception(e, self)
        else:
            @wraps(func)
            def wrapper(*args, **kwargs):
                try:
                    func(*args, **kwargs)
                except Exception as e:
                    process_exception(e)

        return wrapper
    return decorator

def get_config():
    global verbose

    # TODO: understand how looging.basicConfig work
    logging.basicConfig(level=logging.INFO,
                        format='%(levelname)-s: %(message)s')

    shortopts = 'hvs:x:c:t:i:'
    longopts = ['help']
    config = {}
    try:
        optlist, args = getopt.getopt(sys.argv[1:], shortopts, longopts)

        if len(args) == 2:
            config['server'] = args[0]
            config['port'] = int(args[1])
        else:
            print_help()
            sys.exit(1)

        v_count = 0
        for key, value in optlist:
            if key == '-s':
                config['size'] = int(value)
            elif key == '-x':
                config['proxy'] = to_str(value)
            elif key == '-c':
                config['count'] = int(value)
            elif key == '-t':
                config['timeout'] = int(value)
            elif key == '-i':
                config['interval'] = int(value)
            elif key in ('-h', '--help'):
                print_help()
                sys.exit(0)
            elif key == '-v':
                v_count += 1
                config['verbose'] = v_count
    except getopt.GetoptError as e:
        print(e, file=sys.stderr)
        print_help()
        sys.exit(2)

    
    if not config:
        logging.error('config not specified')
        print_help()
        sys.exit(2)
    
    config['size'] = config.get('size', 64)
    config['proxy'] = config.get('proxy', None)
    config['count'] = config.get('count', 10)
    config['timeout'] = config.get('timeout', 3000)
    config['interval'] = config.get('interval', 1000)
    config['verbose'] = config.get('verbose', False)

    verbose = config['verbose']

    return config
    
