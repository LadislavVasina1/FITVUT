"""
File containg the database models for the smartcity app

@author: Dominik Vágner
@email: xvagne10@stud.fit.vutbr.cz

@author: Ladislav Vašina
@email: xvasin11@stud.fit.vutbr.cz

@author: David Novák
@email: xnovak2r@stud.fit.vutbr.cz
"""

import enum

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import relationship, backref
from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    DateTime,
    Date,
    Enum,
    Text,
    Boolean,
    FLOAT,
)
from werkzeug.security import generate_password_hash, check_password_hash

from smartcity.extensions import db


class TicketStateEnum(enum.Enum):
    NEW = "New"
    PLANNED = "Planned"
    WORK_IN_PROGRESS = "Work In Progress"
    DONE = "Done"


class NoticeTypeEnum(enum.Enum):
    ANNOUNCEMENT = "Announcement"
    EXTRAORDINARITY = "Extraordinarity"
    MAINTENANCE = "Maintenance"
    CLOSURE = "Closure"


class RolesUsers(db.Model):
    __tablename__ = "roles_users"
    id = Column(Integer, primary_key=True)
    user_id = Column("user_id", Integer, ForeignKey("user.id"), nullable=False)
    role_id = Column("role_id", Integer, ForeignKey("role.id"), nullable=False)


class Role(db.Model):
    __tablename__ = "role"
    id = Column(Integer, primary_key=True)
    name = Column(String(80), unique=True)
    description = Column(String(255))

    def __repr__(self):
        return f"{self.name}"


class User(db.Model):
    __tablename__ = "user"
    id = Column(Integer, primary_key=True)
    email = Column(String(255), nullable=False, unique=True)
    _password = Column("password", String(255), nullable=False)
    name = Column(String(100), nullable=False)
    surname = Column(String(100), nullable=False)
    authenticated = Column(Boolean, default=False)
    role = relationship("Role", secondary="roles_users")
    deactivated = Column(Boolean, default=False)

    def __repr__(self):
        return f"<User<{self.id}>: email={self.email}, name={self.name}, surname={self.surname},\n roles={self.role}\n>"

    @property
    def is_active(self):
        return True

    @property
    def is_authenticated(self):
        return self.is_active

    @property
    def is_anonymous(self):
        return False

    def get_id(self):
        try:
            return str(self.id)
        except AttributeError:
            raise NotImplementedError("No `id` attribute - override `get_id`") from None

    @property
    def password(self):
        raise AttributeError("Password is not a readable attribute.")

    @password.setter
    def password(self, password):
        self._password = generate_password_hash(password)

    def verify_password(self, password):
        return check_password_hash(self._password, password)

    @property
    def fullname(self):
        return " ".join((self.name, self.surname))


class Ticket(db.Model):
    __tablename__ = "ticket"
    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    description = Column(Text(2048), nullable=False)
    state = Column(Enum(TicketStateEnum), nullable=False, server_default=TicketStateEnum.NEW.value)
    image_path = Column(String(255))
    latitude = Column(FLOAT(precision=10), nullable=False)
    longitude = Column(FLOAT(precision=10), nullable=False)
    reporter_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    assignee_id = Column(Integer, ForeignKey("user.id"))
    created_at = Column(DateTime(), nullable=False)

    def to_dict(self):
        response = {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "state": str(self.state)[str(self.state).find('.')+1:],
            "latitude": self.latitude,
            "longitude": self.longitude,
            "created_at": str(self.created_at),
        }
        return response


class Comment(db.Model):
    __tablename__ = "comment"
    id = Column(Integer, primary_key=True)
    content = Column(Text(2048), nullable=False)
    created_at = Column(DateTime(), nullable=False)
    ticket_id = Column(Integer, ForeignKey("ticket.id"), nullable=False)
    commenter_id = Column(Integer, ForeignKey("user.id"), nullable=False)

class ServiceTaskComment(db.Model):
    __tablename__ = "service_task_comment"
    id = Column(Integer, primary_key=True)
    content = Column(Text(2048), nullable=False)
    created_at = Column(DateTime(), nullable=False)
    service_task_id = Column(Integer, ForeignKey("service_task.id"), nullable=False)
    commenter_id = Column(Integer, ForeignKey("user.id"), nullable=False)


class ServiceTaskUsers(db.Model):
    __tablename__ = "service_task_users"
    id = Column(Integer, primary_key=True)
    user_id = Column("user_id", Integer, ForeignKey("user.id"), nullable=False)
    service_task_id = Column("service_task_id", Integer, ForeignKey("service_task.id"), nullable=False)


class ServiceTask(db.Model):
    __tablename__ = "service_task"
    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    description = Column(Text(2048), nullable=False)
    days_to_complete = Column(Date)
    state = Column(Enum(TicketStateEnum), nullable=False, server_default=TicketStateEnum.NEW.value)
    man_hours = Column(Integer, default=0)
    creator_id = Column(Integer, ForeignKey("user.id"), nullable=False)
    parent_ticket = Column(Integer, ForeignKey("ticket.id"), nullable=False)
    cost = Column(Integer, default=0)
    technicians = relationship("User", secondary="service_task_users", backref=backref("service_task", lazy="dynamic"))


class Notice(db.Model):
    __tablename__ = "notice"
    id = Column(Integer, primary_key=True)
    title = Column(String(255), nullable=False)
    description = Column(Text(2048), nullable=False)
    type = Column(Enum(NoticeTypeEnum), nullable=False, server_default=NoticeTypeEnum.ANNOUNCEMENT.value)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    deleted = Column(Boolean, default=False)
    creator_id = Column(Integer, ForeignKey("user.id"), nullable=False)

    def to_dict(self):
        response = {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "type": str(self.type)[str(self.type).find('.')+1:].capitalize(),
            "start_date": self.start_date.strftime("%m/%d/%Y"),
            "end_date": self.end_date.strftime("%m/%d/%Y")
        }
        return response
