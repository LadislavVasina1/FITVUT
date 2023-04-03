"""
File containing app setup and initialization

@author: Dominik Vágner
@email: xvagne10@stud.fit.vutbr.cz
"""

import os

from flask import Flask, render_template, current_app, Blueprint
from flask_login import current_user
from sqlalchemy import select
from sqlalchemy.exc import NoResultFound
from dotenv import load_dotenv

from smartcity.views.admin_forms import EditUser
from smartcity.views.home import home_bp
from smartcity.views.auth import auth_bp
from smartcity.views.manager import manager_bp
from smartcity.views.admin import admin_bp
from smartcity.views.api.auth import auth_api_bp
from smartcity.views.resident import resident_bp
from smartcity.views.technician import technician_bp
from smartcity.extensions import (
    # migrate,
    login_manager,
    db,
)
from smartcity.models import (
    User,
    Role,
    RolesUsers,
    Ticket,
    Comment,
    ServiceTask,
    ServiceTaskUsers,
    ServiceTaskComment,
)


def create_app():
    """Create application factory."""
    load_dotenv()
    app = Flask(__name__)
    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv("DATABASE_URI")
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config["SECRET_KEY"] = os.getenv("SECRET_KEY")

    register_extensions(app)
    register_blueprints(app)
    register_error_handler(app)

    with app.app_context():
        init_populate_db()

    return app


def register_extensions(app):
    """Register Flask app extensions."""
    # migrate.init_app(app, db)

    login_manager.init_app(app)
    db.init_app(app)
    return None


def register_blueprints(app):
    """Register Flask app blueprints."""
    # Normal View Blueprints
    app.register_blueprint(home_bp)
    app.register_blueprint(auth_bp)
    app.register_blueprint(manager_bp)
    app.register_blueprint(admin_bp)
    app.register_blueprint(resident_bp)
    app.register_blueprint(technician_bp)
    # API Blueprints
    api_bp = Blueprint("api", __name__, url_prefix="/api")
    api_bp.register_blueprint(auth_api_bp)

    app.register_blueprint(api_bp)
    return None


def register_shell_context(app):
    """Register shell context objects."""
    def shell_context():
        return {
            "db": db, "User": User, "Role": Role, "RolesUsers": RolesUsers, "Ticket": Ticket,
            "Comment": Comment, "ServiceTask": ServiceTask, "ServiceTaskUsers": ServiceTaskUsers,
            "ServiceTaskComment": ServiceTaskComment
        }

    app.shell_context_processor(shell_context)


def register_error_handler(app):
    """Register Flask app error handler."""
    def render_error(error):
        error_code = getattr(error, "code", 500)
        if current_user.is_authenticated:
            users = User.query.filter_by(email=current_user.email).first()
            edit_form = EditUser(name=users.name, surname=users.surname, email=users.email, role=users.role[0].name)
            return render_template(f"{error_code}.html", userProfileForm=edit_form), error_code
        else:
            return render_template(f"{error_code}.html"), error_code

    for err in [401, 404, 500]:
        app.errorhandler(err)(render_error)

    return None


@login_manager.user_loader
def user_loader(user_id):
    return User.query.get(user_id)


def init_populate_db():
    with current_app.app_context():
        db.create_all()

        role_dict = {"resident": "Regular city resident.", "technician": "Service technician.",
                     "manager": "City Manager.", "admin": "Smartcity system admin."}
        for name, desc in role_dict.items():
            try:
                db.session.execute(select(Role).where(Role.name == name)).one()
            except NoResultFound:
                new_role = Role(name=name, description=desc)
                db.session.add(new_role)

        user_dict = {
            "resident@sc.com": ["John", "Doe", "resident"],
            "technician@sc.com": ["Borek", "Stavitel", "technician"],
            "manager@sc.com": ["Michael", "Scott", "manager"],
            "admin@sc.com": ["Roy", "Trenneman", "admin"]
        }
        for email, (name, surname, role) in user_dict.items():
            try:
                db.session.execute(select(User).where(User.email == email)).one()
            except NoResultFound:
                role_object = db.session.query(Role).filter_by(name=role).first()
                new_user = User(email=email, password="password", name=name, surname=surname)
                new_user.role.append(role_object)
                db.session.add(new_user)

        db.session.commit()
        db.session.expunge_all()
        db.session.remove()


if __name__ == "__main__":
    myapp = create_app()
    myapp.run()
