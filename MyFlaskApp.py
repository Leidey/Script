from flask import Flask
from flask import render_template
from flask import request
import sqlite3
from werkzeug.contrib.fixers import ProxyFix

app = Flask(__name__)
DATABASE = 'myapp.db'
def connect_db():
    return sqlite3.connect(DATABASE)

@app.route('/')
def home():
    db = connect_db()
    db.close()
    return render_template('Home.html')

@app.route('/existinglist')
def index():
    db = connect_db()
    cur = db.execute( " select id, name, number from people ")
    entries = [dict(id = row[0], name = row[1], number = row[2])for row in cur.fetchall()]
    print(entries)
    db.close()
    return render_template("ProfileList.html", entries = entries )

@app.route('/myprofile')
def showmyprofile():
    return render_template("MyProfile.html")

@app.route('/addprofileform')
def addprofileform():
    return render_template("MyProfileForm.html")

@app.route('/addprofile')
def addprofile():
    myname = request.args.get('myname')
    number = request.args.get('number')
    db = connect_db()
    sql = " insert into people (name,number) values (?,?)"
    db.execute(sql, [myname, number])
    db.commit()
    db.close()
    return render_template("MyProfile.html", html_myname = myname, html_number = number)

@app.route('/editprofile')
def editprofile():
    id = request.args.get('id')
    db = connect_db()
    cur = db.execute("select id, name, number from people where id = ? ", [id])
    rv = cur.fetchall()
    cur.close()
    person = rv[0]
    print(rv[0])
    db.close()
    return  render_template('MyProfileUpdateForm.html', person = person)

@app.route('/updateprofile')
def updateprofile():
    id = request.args.get('id')
    myname = request.args.get('myname')
    number = request.args.get('number')
    db = connect_db()
    sql = "update people SET name=?, number=? WHERE id=?"
    db.execute(sql,[myname,number,id])
    db.commit()
    db.close()
    return  index()

@app.route('/deleteprofile')
def deleteprofile():
    id = request.args.get('id')
    db = connect_db()
    sql = "delete from people where id=?"
    db.execute(sql,[id])
    db.commit()
    db.close()
    return index()

app.wsgi_app = ProxyFix(app.wsgi_app)

if __name__ == '__main__':
    app.run(host="0.0.0.0",debug=True)

