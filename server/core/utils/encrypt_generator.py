from dataclasses import dataclass
import bcrypt


@dataclass
class EncryptionUtility:
    @staticmethod
    def encrypt(plain_text: str):
        return bcrypt.hashpw(plain_text.encode(), bcrypt.gensalt()).decode()

    @staticmethod
    def verify_password(plain_text: str, encrpted_text: str):
        return bcrypt.checkpw(plain_text.encode(), encrpted_text.encode())
