"""
WSGI config for shareyourheart project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/3.2/howto/deployment/wsgi/
"""

import os

from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'shareyourheart.settings')

application = get_wsgi_application()

os.environ["DJANGO_ALLOW_ASYNC_UNSAFE"] = "true"
