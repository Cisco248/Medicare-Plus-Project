from abc import ABC, abstractmethod
from typing import Any


class BaseLoader(ABC):

    @abstractmethod
    def loader(self) -> Any:
        pass
