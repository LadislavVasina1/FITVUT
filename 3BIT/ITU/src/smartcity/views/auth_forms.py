"""
File containing the forms for the auth views

@author: Dominik Vágner
@email: xvagne10@stud.fit.vutbr.cz
"""

from wtforms.validators import Email, DataRequired, Length, EqualTo
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, BooleanField


class LoginForm(FlaskForm):
    email = StringField("Email Address", [Email(), DataRequired(message="Forgot your email address?")])
    password = PasswordField("Password", [DataRequired(message="You must provide a password.")])
    remember = BooleanField("Remember Me")


class SignupForm(FlaskForm):
    name = StringField("Name", [DataRequired(message="Forgot your name?")])
    surname = StringField("Surname", [DataRequired(message="Forgot your surname?")])
    email = StringField("Email Address", [Email(), DataRequired(message="Forgot your email address?")])
    password = PasswordField("Password", [
        DataRequired(message="You must provide a password."),
        Length(min=8, message="Password must be at least 8 characters long."),
        EqualTo("confirm", message="Passwords must match.")
    ])
    confirm = PasswordField("Repeat Password", [EqualTo("password", message="Passwords must match.")])
