"""
File containing whole website API

@author: Dominik Vágner
@email: xvagne10@stud.fit.vutbr.cz

@author: Ladislav Vašina
@email: xvasin11@stud.fit.vutbr.cz

@author: David Novák
@email: xnovak2r@stud.fit.vutbr.cz
"""

import datetime
import base64
import json

from datetime import datetime, date

from flask import Blueprint, request, jsonify, make_response, current_app, url_for
from flask_login import login_required, login_user, logout_user, current_user

from smartcity.views import roles_required
from smartcity.models import User, Role, db, ServiceTaskUsers, ServiceTask, Ticket, Comment, ServiceTaskComment, \
    TicketStateEnum, NoticeTypeEnum, Notice

auth_api_bp = Blueprint("auth_api", __name__)


@auth_api_bp.route("/signup", methods=["POST"])
def signup():
    data = request.get_json()
    with current_app.app_context():
        user = User.query.filter_by(email=data.get("email")).first()
        if user:
            if user.email == data.get("email"):
                response_object = {
                    "status": "fail",
                    "message": "User already exists. Please log in.",
                }
                return make_response(jsonify(response_object), 401)
        else:
            try:
                new_user = User(
                    email=data.get("email"),
                    password=data.get("password"),
                    name=data.get("name"),
                    surname=data.get("surname"),
                )
                if data.get("role") == 1:
                    role = Role.query.filter_by(name="resident").first()
                    if not role:
                        raise AttributeError
                elif data.get("role") == 2:
                    role = Role.query.filter_by(name="technician").first()
                    if not role:
                        raise AttributeError
                elif data.get("role") == 3:
                    role = Role.query.filter_by(name="manager").first()
                    if not role:
                        raise AttributeError
                elif data.get("role") == 4:
                    role = Role.query.filter_by(name="admin").first()
                    if not role:
                        raise AttributeError
                new_user.role.append(role)
                db.session.expunge_all()
                db.session.add(new_user)
                db.session.commit()
                db.session.expunge_all()
                response_object = {
                    "status": "success",
                    "message": "User successfully registered.",
                }
                return make_response(jsonify(response_object), 201)
            except Exception as e:
                print(e)
                response_object = {
                    "status": "fail",
                    "message": "An error has occurred. Please try again.",
                }
                return make_response(jsonify(response_object), 500)


@auth_api_bp.route("/login", methods=["POST"])
def login():
    data = request.get_json()

    if not current_user.is_anonymous:
        response_object = {
            "status": "fail",
            "message": "User already logged in.",
        }
        return make_response(jsonify(response_object), 401)

    with current_app.app_context():
        user = User.query.filter_by(email=data.get("email")).first()
        if not user:
            response_object = {
                "status": "fail",
                "message": "Incorrect credentials",
            }
            return make_response(jsonify(response_object), 401)
        else:
            if user.deactivated:
                response_object = {
                    "status": "fail",
                    "message": "User deactivated.",
                }
                return make_response(jsonify(response_object), 401)
            elif not user.verify_password(password=data.get("password")):
                response_object = {
                    "status": "fail",
                    "message": "Incorrect credentials.",
                }
                return make_response(jsonify(response_object), 401)
            else:
                login_user(user, remember=data.get("remember"))
                response_object = {
                    "status": "success",
                    "message": "User successfully logged in.",
                }
                role_name = user.role[0].name
                if role_name == "resident":
                        response_object.update({"location": url_for("resident.map_of_tickets")})
                elif role_name == "technician":
                    response_object.update({"location": url_for("technician.assigned_tasks")})
                elif role_name == "manager":
                    response_object.update({"location": url_for("manager.manager_dashboard")})
                elif role_name == "admin":
                    response_object.update({"location": url_for("admin.admin_dashboard")})

                return make_response(jsonify(response_object), 200)


@login_required
@auth_api_bp.route("/logout", methods=["POST"])
def logout():
    logout_user()
    response_object = {
        "status": "success",
        "message": "User successfully logged out.",
    }
    return make_response(jsonify(response_object), 200)


@login_required
@roles_required(["manager"])
@auth_api_bp.route("/create_service_task", methods=["POST"])
def create_service_task():
    data = request.get_json()
    with current_app.app_context():
        try:
            new_service_task = ServiceTask(
                name=data.get("name"),
                description=data.get("description"),
                creator_id=int(data.get("creator_id")),
                parent_ticket=int(data.get("parent_ticket")),
            )
            technician = User.query.filter_by(id=data.get("technician_id")).first()
            new_service_task.technicians.append(technician)
            db.session.expunge_all()
            db.session.add(new_service_task)

            db.session.flush()

            new_service_task_users = ServiceTaskUsers(
                user_id=data.get("technician_id"),
                service_task_id=new_service_task.id,
            )
            db.session.expunge_all()
            db.session.add(new_service_task_users)
            db.session.commit()
            db.session.expunge_all()

            db.session.flush()

            db.session.execute(
                "DELETE FROM service_task_users WHERE id NOT IN (SELECT * FROM (SELECT MIN(id) FROM service_task_users GROUP BY user_id, service_task_id) AS t)")
            db.session.commit()

            response_object = {
                "status": "success",
                "message": "Service task successfully created.",
            }
            return make_response(jsonify(response_object), 201)
        except Exception as e:
            print(e)
            response_object = {
                "status": "fail",
                "message": "An error has occurred. Please try again.",
            }
            return make_response(jsonify(response_object), 500)



@login_required
@roles_required(["admin"])
@auth_api_bp.route("/delete_user", methods=["POST"])
def delete_user():
    data = request.get_json()
    with current_app.app_context():
        try:
            db.session.query(User).filter(User.id == int(data.get("user_id"))).update({"deactivated": 1})
            db.session.commit()
            db.session.expunge_all()
        except Exception as e:
            print(e)
            response_object = {
                "status": "fail",
                "message": "An error has occurred. Please try again.",
            }
            return make_response(jsonify(response_object), 500)

    response_object = {
        "status": "success",
        "message": "User successfully deleted.",
    }
    return make_response(jsonify(response_object), 200)


@login_required
@roles_required(["admin"])
@auth_api_bp.route("/edit_user", methods=["POST"])
def edit_user():
    data = request.get_json()
    with current_app.app_context():
        try:
            if data.get("password") == "":
                db.session.query(User).filter(User.id == int(data.get("user_id"))).update(
                    {"email": data.get("email"),
                     "name": data.get("name"),
                     "surname": data.get("surname")
                     })
            else:
                user = User.query.filter_by(email=data.get("email")).first()
                db.session.query(User).filter(User.id == int(data.get("user_id"))).update(
                    {"email": data.get("email"),
                     "name": data.get("name"),
                     "surname": data.get("surname")
                     })
                user = User.query.filter_by(email=data.get("email")).first()
                user.password = data.get("password")

            db.session.commit()
            db.session.expunge_all()

            response_object = {
                "status": "success",
                "message": "User successfully deleted.",
            }
            return make_response(jsonify(response_object), 200)
        except Exception as e:
            print(e)
            response_object = {
                "status": "fail",
                "message": "An error has occurred. Please try again.",
            }
            return make_response(jsonify(response_object), 500)


@login_required
@roles_required(["manager"])
@auth_api_bp.route("/edit_state", methods=["POST"])
def edit_state():
    data = request.get_json()
    with current_app.app_context():
        try:
            db.session.query(Ticket).filter(Ticket.id == int(data.get("ticket_id"))).update(
                {"state": data.get("state")})
            db.session.commit()
            db.session.expunge_all()

            response_object = {
                "status": "success",
                "message": "State successfully changed.",
            }
            return make_response(jsonify(response_object), 200)
        except Exception as e:
            print(e)
            response_object = {
                "status": "fail",
                "message": "An error has occurred. Please try again.",
            }
            return make_response(jsonify(response_object), 500)


@login_required
@roles_required(["manager"])
@auth_api_bp.route("/add_comment", methods=["POST"])
def add_comment():
    data = request.get_json()
    with current_app.app_context():
        try:
            new_comment = Comment(
                content = data.get("content"),
                created_at = data.get("created_at"),
                ticket_id = data.get("ticket_id"),
                commenter_id = data.get("commenter_id")
            )
            db.session.add(new_comment)
            db.session.commit()
            db.session.expunge_all()

            response_object = {
                "status": "success",
                "message": "State successfully changed.",
            }
            return make_response(jsonify(response_object), 200)
        except Exception as e:
            print(e)
            response_object = {
                "status": "fail",
                "message": "An error has occurred. Please try again.",
            }
            return make_response(jsonify(response_object), 500)


@login_required
@roles_required(["resident"])
@auth_api_bp.route("/new_ticket", methods=["POST"])
def create_new_ticket():
    data = request.get_json()
    with current_app.app_context():
        try:
            if data.get("latitude") is None or data.get("latitude") == "-1000":
                response_object = {
                    "status": "fail",
                    "message": "Please select a location.",
                }
                return make_response(jsonify(response_object), 400)
            new_ticket: Ticket
            rep = data.get("reporter_id")
            img = data.get('image')
            if img != '':
                img = img[len('data:image/'):]
                end = img[:img.find(';')]
                img = img[img.find(',')+1:]
                dt = datetime.now().strftime("%m%d%Y%H%M%S")
                f = "/static/images/" + dt + rep + '.' + end
                with open('smartcity' + f, "wb") as fh:
                    fh.write(base64.b64decode(img))

                new_ticket = Ticket(
                    reporter_id=int(rep),
                    name=data.get("name"),
                    description=data.get("description"),
                    latitude=float(data.get("latitude").replace(",", ".")),
                    longitude=float(data.get("longitude").replace(",", ".")),
                    image_path=f,
                    created_at=datetime.now()
                )
            else:
                new_ticket = Ticket(
                    reporter_id=int(rep),
                    name=data.get("name"),
                    description=data.get("description"),
                    latitude=float(data.get("latitude").replace(",", ".")),
                    longitude=float(data.get("longitude").replace(",", ".")),
                    created_at=datetime.now()
                )

            db.session.expunge_all()
            db.session.add(new_ticket)
            db.session.commit()

            response_object = {
                "status": "success",
                "message": "Service task successfully created.",
            }
            return make_response(jsonify(response_object), 201)
        except Exception as e:
            print(e)
            response_object = {
                "status": "fail",
                "message": "An error has occurred. Please try again.",
            }
            return make_response(jsonify(response_object), 500)

@login_required
@roles_required(["technician", "manager"])
@auth_api_bp.route("/add_task_comment", methods=["POST"])
def add_task_comment():
    data = request.get_json()
    with current_app.app_context():
        try:
            new_comment = ServiceTaskComment(
                content = data.get("content"),
                created_at = data.get("created_at"),
                service_task_id = data.get("service_task_id"),
                commenter_id = data.get("commenter_id")
            )
            db.session.add(new_comment)
            db.session.commit()
            db.session.expunge_all()

            response_object = {
                "status": "success",
                "message": "State successfully changed.",
            }
            return make_response(jsonify(response_object), 200)
        except Exception as e:
            print(e)
            response_object = {
                "status": "fail",
                "message": "An error has occurred. Please try again.",
            }
            return make_response(jsonify(response_object), 500)


@login_required
@roles_required(["resident"])
@auth_api_bp.route("/get_tickets", methods=["GET"])
def get_tickets():
    with current_app.app_context():
        tickets = db.session.query(Ticket).all()
        ticket_dict = [entry.to_dict() for entry in tickets]
        response_object = json.dumps(ticket_dict)
        return make_response(jsonify(response_object), 200)


@login_required
@roles_required(["technician"])
@auth_api_bp.route("/update_service_task", methods=["POST"])
def update_service_task():
    data = request.get_json()
    with current_app.app_context():
        try:
            db.session.query(ServiceTask).filter(ServiceTask.id == int(data.get("id"))).update(
                {"cost" : int(data.get("cost")), "man_hours" : int(data.get("man_hours")), "days_to_complete" : data.get("completion"), "state" : TicketStateEnum(data.get("task_state"))})
            db.session.commit()
            db.session.expunge_all()

            response_object = {
                "status": "success",
                "message": "Task successfully updated.",
            }
            return make_response(jsonify(response_object), 200)
        except Exception as e:
            print(e)
            response_object = {
                "status": "fail",
                "message": "An error has occurred. Please try again.",
            }
            return make_response(jsonify(response_object), 500)


@login_required
@roles_required(["manager"])
@auth_api_bp.route("/create_notice", methods=["POST"])
def create_notice():
    data = request.get_json()
    with current_app.app_context():
        try:
            duration = data.get("duration")
            start_date, end_date = [datetime.strptime(x, '%m/%d/%Y') for x in duration.split(" - ")]
            new_notice = Notice(
                title=data.get("title"),
                description=data.get("description"),
                type=NoticeTypeEnum(data.get("type")),
                start_date=start_date,
                end_date=end_date,
                deleted=False,
                creator_id=data.get("creator_id"),
            )
            db.session.add(new_notice)
            db.session.commit()
            db.session.expunge_all()

            response_object = {
                "status": "success",
                "message": "State successfully changed.",
            }
            return make_response(jsonify(response_object), 200)
        except Exception as e:
            print(e)
            response_object = {
                "status": "fail",
                "message": "An error has occurred. Please try again.",
            }
            return make_response(jsonify(response_object), 500)


@login_required
@auth_api_bp.route("/query_notices", methods=["POST"])
def query_notices():
    data = request.get_json()
    with current_app.app_context():
        try:
            notice_type = data.get("type")
            daterange = data.get("daterange")
            notices = db.session.query(Notice).filter(Notice.deleted == 0).all()

            if notice_type.lower() != "all types":
                notices = [x for x in notices if x.type.value.lower() == notice_type.lower()]
            if daterange:
                start_date, end_date = [datetime.strptime(x, '%m/%d/%Y').date() for x in daterange.split(" - ")]
                notices = [x for x in notices if start_date <= x.end_date and end_date >= x.start_date]

            notice_dict = [entry.to_dict() for entry in notices]
            response_object = json.dumps(notice_dict)
            return make_response(jsonify(response_object), 200)
        except Exception as e:
            print(e)
            response_object = {
                "status": "fail",
                "message": "An error has occurred. Please try again.",
            }
            return make_response(jsonify(response_object), 500)


@login_required
@roles_required(["manager"])
@auth_api_bp.route("/edit_notice", methods=["POST"])
def edit_notice():
    data = request.get_json()
    with current_app.app_context():
        try:
            notice_title = data.get("notice_title")
            notice_type = data.get("notice_type")
            notice_duration = data.get("notice_duration")
            notice_description = data.get("notice_description")

            if notice_title == "undefined" or notice_title == "":
                response_object = {
                    "status": "fail",
                    "message": "Invalid or empty Title.",
                }
                return make_response(jsonify(response_object), 400)
            if notice_type == "undefined" or notice_type == "":
                response_object = {
                    "status": "fail",
                    "message": "Type not selected.",
                }
                return make_response(jsonify(response_object), 400)
            if notice_type not in [e.value for e in NoticeTypeEnum]:
                response_object = {
                    "status": "fail",
                    "message": "Invalid Type.",
                }
                return make_response(jsonify(response_object), 400)
            if notice_description == "undefined" or notice_description == "":
                response_object = {
                    "status": "fail",
                    "message": "Invalid or empty description.",
                }
                return make_response(jsonify(response_object), 400)
            if notice_duration == "undefined" or notice_duration == "":
                response_object = {
                    "status": "fail",
                    "message": "Invalid or empty duration.",
                }
                return make_response(jsonify(response_object), 400)
            try:
                start_date, end_date = [datetime.strptime(x, '%m/%d/%Y') for x in notice_duration.split(" - ")]
            except Exception as e:
                print(e)
                response_object = {
                    "status": "fail",
                    "message": "Invalid duration format.",
                }
                return make_response(jsonify(response_object), 400)

            db.session.query(Notice).filter(Notice.id == int(data.get("notice_id"))).update({
                "title": notice_title,
                "type": NoticeTypeEnum(notice_type),
                "start_date": start_date,
                "end_date": end_date,
                "description": notice_description,
            })
            db.session.commit()
            db.session.expunge_all()

            response_object = {
                "status": "success",
                "message": "Notice successfully updated.",
            }
            return make_response(jsonify(response_object), 200)
        except Exception as e:
            print(e)
            response_object = {
                "status": "fail",
                "message": "An error has occurred. Please try again.",
            }
            return make_response(jsonify(response_object), 500)


@login_required
@roles_required(["manager"])
@auth_api_bp.route("/delete_notice", methods=["POST"])
def delete_notice():
    data = request.get_json()
    with current_app.app_context():
        try:
            notice_id = data.get("notice_id")
            print(notice_id)
            db.session.query(Notice).filter(Notice.id == notice_id).update({"deleted": 1})
            db.session.commit()
            db.session.expunge_all()
            response_object = {
                "status": "success",
                "message": "State successfully changed.",
            }
            return make_response(jsonify(response_object), 200)
        except Exception as e:
            print(e)
            response_object = {
                "status": "fail",
                "message": "An error has occurred. Please try again.",
            }
            return make_response(jsonify(response_object), 500)
