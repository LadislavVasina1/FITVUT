"""
File containing functions that renders technician's views

@author: David Novák
@email: xnovak2r@stud.fit.vutbr.cz
"""

from flask import Blueprint, request, jsonify, make_response, current_app, render_template
from flask_login import login_required, login_user, logout_user, current_user
from sqlalchemy import desc

from smartcity.models import User, Role, RolesUsers, ServiceTask, ServiceTaskUsers, Comment, Ticket, TicketStateEnum, \
    db, ServiceTaskComment
from smartcity.views import roles_required
from .admin_forms import EditUser
from .technician_forms import UpdateServiceTask

technician_bp = Blueprint("technician", __name__)


@technician_bp.route("/assigned_tasks", methods=["GET", "POST"])
@login_required
@roles_required(["technician"])
def assigned_tasks():
    service_tasks = ServiceTask.query.join(ServiceTaskUsers).filter(ServiceTaskUsers.user_id == current_user.id).all()
    users = User.query.filter_by(email=current_user.email).first()
    edit_form = EditUser(name=users.name, surname=users.surname, email=users.email, role=users.role[0].name)
    return render_template("technician/assigned_tasks.html", current_user=current_user, service_tasks=service_tasks,
                           userProfileForm=edit_form)


@technician_bp.route("/task_view", methods=["GET", "POST"])
@login_required
@roles_required(["technician", "manager"])
def task_view():
    task_form = UpdateServiceTask()
    ticket = Ticket.query.join(ServiceTask).filter(Ticket.id == request.args.get("parent")).all()
    task = ServiceTask.query.filter(ServiceTask.id == request.args.get("taskID")).all()
    comments = ServiceTaskComment.query.filter(ServiceTaskComment.service_task_id == task[0].id).all()
    users = User.query.filter_by(email=current_user.email).first()
    edit_form = EditUser(name=users.name, surname=users.surname, email=users.email, role=users.role[0].name)
    all_users = User.query.all()
    return render_template("technician/task_view.html", current_user=current_user, ticket=ticket,
                           comments=comments, task=task, userProfileForm=edit_form, all_users=all_users,
                           form=task_form)
