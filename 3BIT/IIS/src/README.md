# IIS

Smart City website. \
Team project for the "IIS - Information Systems" subject. 

## Local Setup
Install and start a MySQL server on your machine and create a database named `smartcity`.\
After that copy the environment variable overrides file like so `cp .env.example .env`. \
Edit the `DATABASE_URI` variable in `.env` to match your MySQL setup and run these next few commands:
```shell
virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
flask run --host=0.0.0.0
```
#### On every `git pull`:
Once you setup your `.env` file for local environment, copy to somewhere (for example: `cp .env .myenv`) \
Don't include that file in git commits. \
After every `git pull` run something like this `cp .myenv .env`

## Images
Save images in the `smartcity/static/images` folder. \
Set ticket attribute `image_path` with prefix `/static/images/` followed by the image name (e.g. `/static/images/image.png`).
### Example usage
Then in image tag use `src="{{ ticket.image_path }}"` to display the image.
