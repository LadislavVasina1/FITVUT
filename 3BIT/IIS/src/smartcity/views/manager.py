"""
File containing functions that renders manager's templates

@author: Ladislav Vašina
@email: xvasin11@stud.fit.vutbr.cz

@author: Dominik Vágner
@email: xvagne10@stud.fit.vutbr.cz
"""

from flask import Blueprint, request, jsonify, make_response, current_app, render_template
from flask_login import login_required, login_user, logout_user, current_user
from smartcity.views import roles_required
from smartcity.models import User, Role, RolesUsers, ServiceTask, ServiceTaskUsers, Comment, Ticket, TicketStateEnum, db

from smartcity.views.manager_forms import CreateTechnician, CreateServiceTask, CreateNotice
from .admin_forms import EditUser
manager_bp = Blueprint("manager", __name__)


@manager_bp.route("/manager_dashboard", methods=["GET", "POST"])
@login_required
@roles_required(["manager"])
def manager_dashboard():
    tickets = Ticket.query.all()
    all_users = User.query.all()
    users = User.query.filter_by(email=current_user.email).first()
    edit_form = EditUser(name=users.name, surname=users.surname, email=users.email, role=users.role[0].name)
    return render_template("manager/manager_dashboard.html", current_user=current_user, tickets=tickets,
                           all_users=all_users, userProfileForm=edit_form)


@manager_bp.route("/create_technician", methods=["GET", "POST"])
@login_required
@roles_required(["manager"])
def create_technician():
    create_technician_form = CreateTechnician()
    if request.method == "POST":
        if create_technician_form.validate():
            response_object = {
                "status": "success", "message": "Form verification successful"
            }
            return jsonify(response_object), 200
        else:
            return jsonify(create_technician_form.errors), 400
    users = User.query.filter_by(email=current_user.email).first()
    edit_form = EditUser(name=users.name, surname=users.surname, email=users.email, role=users.role[0].name)
    return render_template("manager/create_technician.html", current_user=current_user, form=create_technician_form, userProfileForm=edit_form)


@manager_bp.route("/create_service_task", methods=["GET", "POST"])
@login_required
@roles_required(["manager"])
def create_service_task():
    tickets = Ticket.query.all()
    service_technicians = User.query.join(RolesUsers).filter(RolesUsers.role_id == 2).all()
    create_service_task_form = CreateServiceTask(service_technicians)
    users = User.query.filter_by(email=current_user.email).first()
    edit_form = EditUser(name=users.name, surname=users.surname, email=users.email, role=users.role[0].name)
    return render_template("manager/create_service_task.html", current_user=current_user, form=create_service_task_form,
                           service_technicians=service_technicians, tickets=tickets, userProfileForm=edit_form)


@manager_bp.route("/manager_ticket_view", methods=["GET", "POST"])
@login_required
@roles_required(["manager"])
def manager_ticket_view():
    if request.method == "GET":
        ticket_comments = Comment.query.filter_by(ticket_id=request.args.get("ticketId")).all()
        tickets_tasks = ServiceTask.query.filter_by(parent_ticket=request.args.get("ticketId")).all()
        try:
            selected_ticket_id = int(request.args.get("ticketId"))
        except Exception as e:
            return render_template("204.html")
    tickets = Ticket.query.all()
    all_users = User.query.all()
    service_technicians = User.query.join(RolesUsers).filter(RolesUsers.role_id == 2).all()
    users = User.query.filter_by(email=current_user.email).first()
    edit_form = EditUser(name=users.name, surname=users.surname, email=users.email, role=users.role[0].name)
    return render_template("manager/manager_ticket_view.html", current_user=current_user,
                           service_technicians=service_technicians, tickets=tickets,
                           selected_ticket_id=selected_ticket_id, all_users=all_users, ticket_comments=ticket_comments,
                           tickets_tasks=tickets_tasks, userProfileForm=edit_form)


@manager_bp.route("/manager_message_board", methods=["GET", "POST"])
@login_required
@roles_required(["manager"])
def manager_message_board():
    create_notice_form = CreateNotice()
    if request.method == "POST":
        if create_notice_form.validate():
            response_object = {
                "status": "success", "message": "Form verification successful"
            }
            return jsonify(response_object), 200
        else:
            return jsonify(create_notice_form.errors), 400
    users = User.query.filter_by(email=current_user.email).first()
    edit_form = EditUser(name=users.name, surname=users.surname, email=users.email, role=users.role[0].name)
    return render_template(
        "manager/manager_message_board.html",
        current_user=current_user,
        userProfileForm=edit_form,
        create_form=create_notice_form
    )
