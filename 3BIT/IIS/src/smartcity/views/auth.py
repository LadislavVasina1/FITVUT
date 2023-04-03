"""
File containing functions that renders login and signup templates

@author: Dominik Vágner
@email: xvagne10@stud.fit.vutbr.cz
"""

from flask import Blueprint, render_template, request, jsonify, make_response, flash
from flask_login import current_user

from smartcity.views.auth_forms import LoginForm, SignupForm

auth_bp = Blueprint("auth", __name__)


@auth_bp.route("/login", methods=["GET", "POST"])
def login():
    login_form = LoginForm()
    if request.method == "POST":
        if login_form.validate():
            response_object = {
                "status": "success", "message": "Form verification successful"
            }
            return jsonify(response_object), 200
        else:
            return jsonify(login_form.errors), 400
    return render_template("public/login.html", form=login_form)


@auth_bp.route("/signup", methods=["GET", "POST"])
def signup():
    signup_form = SignupForm()
    if request.method == "POST":
        if signup_form.validate():
            response_object = {
                "status": "success", "message": "Form verification successful"
            }
            return jsonify(response_object), 200
        else:
            return jsonify(signup_form.errors), 400
    return render_template("public/signup.html", form=signup_form)
