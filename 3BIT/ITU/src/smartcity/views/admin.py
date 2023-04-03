"""
File containing functions that renders admin's templates

@author: Ladislav Vašina
@email: xvasin11@stud.fit.vutbr.cz
"""

from flask import Blueprint, request, jsonify, make_response, current_app, render_template
from flask_login import login_required, login_user, logout_user, current_user
from smartcity.views import roles_required
from smartcity.models import User, Role, RolesUsers, ServiceTask, ServiceTaskUsers, Comment, Ticket, TicketStateEnum, db

from .admin_forms import CreateCityManager, EditUser
from .admin_forms import EditUser
admin_bp = Blueprint("admin", __name__)


@admin_bp.route("/admin_dashboard", methods=["GET", "POST"])
@login_required
@roles_required(["admin"])
def admin_dashboard():
    all_users = User.query.all()
    forms_list = []
    for user in all_users:
        edit_form = EditUser(name=user.name, surname=user.surname, email=user.email, role=user.role[0].name)
        forms_list.append(edit_form)
    users = User.query.filter_by(email=current_user.email).first()
    edit_form = EditUser(name=users.name, surname=users.surname, email=users.email, role=users.role[0].name)
    return render_template("admin/admin_dashboard.html", current_user=current_user, all_users=all_users, form=edit_form,
                           forms_list=forms_list, userProfileForm=edit_form)


@admin_bp.route("/create_city_manager", methods=["GET", "POST"])
@login_required
@roles_required(["admin"])
def create_city_manager():
    create_city_manager_form = CreateCityManager()
    if request.method == "POST":
        if create_city_manager_form.validate():
            response_object = {
                "status": "success", "message": "Form verification successful"
            }
            return jsonify(response_object), 200
        else:
            return jsonify(create_city_manager_form.errors), 400
    users = User.query.filter_by(email=current_user.email).first()
    edit_form = EditUser(name=users.name, surname=users.surname, email=users.email, role=users.role[0].name)
    return render_template("admin/create_city_manager.html", current_user=current_user, form=create_city_manager_form, userProfileForm=edit_form)
