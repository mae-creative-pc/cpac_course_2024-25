from django.db import models as M
MAX_LENGTH=50

class Text(M.Model):
    text = M.CharField(max_length=MAX_LENGTH)