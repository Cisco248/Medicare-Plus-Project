import uuid
import string

alphabet = string.digits + string.ascii_letters


def base62_encode(num):
    base = len(alphabet)
    s = ""
    while num:
        num, rem = divmod(num, base)
        s = alphabet[rem] + s
    return s


def short_uuid():
    u = uuid.uuid4().int
    return base62_encode(u)
