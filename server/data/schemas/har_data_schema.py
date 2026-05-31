from pydantic import BaseModel


class HARDataScheme(BaseModel):
    x_axis_accelorometer: float
    y_axis_accelorometer: float
    z_axis_accelorometer: float
    x_axis_gyroscopemeter: float
    y_axis_gyroscopemeter: float
    z_axis_gyroscopemeter: float
