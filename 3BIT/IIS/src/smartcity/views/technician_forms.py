"""
File containing the forms for the technician views

@author: David Novák
@email: xnovak2r@stud.fit.vutbr.cz
"""

from flask_wtf import FlaskForm
from wtforms import StringField
from wtforms.validators import DataRequired, Length, EqualTo


class UpdateServiceTask(FlaskForm):
    id = StringField("id")
    cost = StringField("cost", [DataRequired(message="Forgot to set cost?")])
    man_hours = StringField("man_hours", [DataRequired(message="Forgot calculate man-hours?")])
    completion = StringField("completion", [DataRequired(message="Forgot pass planned date of completion?")])
    task_state = StringField("task_state", [DataRequired(message="No state passed.")])
