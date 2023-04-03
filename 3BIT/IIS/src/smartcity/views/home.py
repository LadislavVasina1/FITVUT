"""
File contains function that renders main page template

@author: Dominik Vágner
@email: xvagne10@stud.fit.vutbr.cz
"""

from flask import Blueprint, render_template
from flask_login import current_user, login_required
from smartcity.views import roles_required
from smartcity.models import Role, User

from .admin_forms import EditUser

home_bp = Blueprint("home", __name__)


@home_bp.route("/", methods=["GET", "POST"])
def index():
    roles = Role.query.all()
    if current_user.is_anonymous:
        users = None
    else:
        users = User.query.filter_by(email=current_user.email).first()
    if current_user.is_authenticated:
        edit_form = EditUser(name=users.name, surname=users.surname, email=users.email, role=users.role[0].name)
        return render_template("public/index.html", roles=roles, users=users, current_user=current_user, userProfileForm=edit_form)
    else:
        return render_template("public/index.html", roles=roles, users=users, current_user=current_user)
