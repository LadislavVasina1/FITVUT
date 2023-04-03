"""
File containing forms for the manager views

@author: Ladislav Vašina
@email: xvasin11@stud.fit.vutbr.cz
"""

from wtforms.validators import Email, DataRequired, Length, EqualTo
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, BooleanField

class CreateCityManager(FlaskForm):
    name = StringField("Name", [DataRequired(message="Forgot manager name?")])
    surname = StringField("Surname", [DataRequired(message="Forgot manager surname?")])
    email = StringField("Email Address", [Email(), DataRequired(message="Forgot manager email address?")])
    password = PasswordField("Password", [
        DataRequired(message="You must provide a password."),
        Length(min=8, message="Password must be at least 8 characters long."),
        EqualTo("confirm", message="Passwords must match.")
    ])
    confirm = PasswordField("Repeat Password", [EqualTo("password", message="Passwords must match.")])


class EditUser(FlaskForm):
    id = StringField("Id")
    name = StringField("Name", [DataRequired(message="Forgot user's name?")])
    surname = StringField("Surname", [DataRequired(message="Forgot user's surname?")])
    email = StringField("Email Address", [Email(), DataRequired(message="Forgot user's email address?")])
    password = PasswordField("New password", [
        Length(min=8, message="Password must be at least 8 characters long."),
    ], render_kw={"placeholder": "If left empty password will not be changed"})
    role = StringField("Role", [DataRequired(message="Forgot user's role?")])
    confirm = PasswordField("Repeat Password", [EqualTo("password", message="Passwords must match.")])
