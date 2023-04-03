"""
Setup extensions

@author: Dominik Vágner
@email: xvagne10@stud.fit.vutbr.cz
"""

# from flask_migrate import Migrate
from flask_login import LoginManager
from flask_sqlalchemy import SQLAlchemy

# migrate = Migrate()
login_manager = LoginManager()
db = SQLAlchemy()

