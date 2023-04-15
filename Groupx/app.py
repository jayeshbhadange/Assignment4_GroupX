from flask import Flask, render_template, request, redirect, flash, session
from flask_mysqldb import MySQL
import yaml
from flask import flash
from time import sleep
from datetime import datetime

app = Flask(__name__)
app.config['SECRET_KEY'] = 'mysecretkey'
# Configure db
db = yaml.safe_load(open('db.yaml'))
app.config['MYSQL_HOST'] = db['mysql_host']
app.config['MYSQL_USER'] = db['mysql_user']
app.config['MYSQL_PASSWORD'] = db['mysql_password']
app.config['MYSQL_DB'] = db['mysql_db']

mysql = MySQL(app)

@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.values.get("email")
        password = request.values.get('password').encode('utf-8')
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM login_db WHERE email = %s", (email,))
        admin = cur.fetchone()
        cur.close()
        cur1 = mysql.connection.cursor()
        cur1.execute("SELECT * FROM users_credentials WHERE email = %s", (email,))
        user = cur1.fetchone()
        cur1.close()
        passcode = 0
        passcode1 = 0
        if 1:
            if admin: 
                passcode = admin[1].encode('utf-8')
                if password == passcode:
                    # Store user information in session
                    session['email'] = email
                    session['admin'] = True
                    return redirect('/DBMS')
            elif user:
                passcode1 = user[1].encode('utf-8')
                if password == passcode1:
                    # Store user information in session
                    session['email'] = email
                    session['user'] = True
                    return redirect('/dbmsuser')
            else:
                return redirect('/')
    return render_template('loginpage.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        # Retrieve the user input from the form
        first_name = request.form['first_name']
        middle_name = request.form['middle_name']
        last_name = request.form['last_name']
        email = request.form['email']
        password = request.form['password']

        # Open a database connection
        cur = mysql.connection.cursor()

        # Check if the email already exists in the users table
        cur.execute("SELECT * FROM users WHERE email = %s", [email])
        user = cur.fetchone()

        # If the user already exists, show an error message
        if user:
            flash('An account already exists for this email address.', 'error')
            return redirect('/signup')

        # Insert user details into the users table
        cur.execute("INSERT INTO users (first_name, middle_name, last_name, email) VALUES (%s, %s, %s, %s)", (first_name, middle_name, last_name, email))
        mysql.connection.commit()

        # Insert user credentials into the users_credential table
        cur.execute("INSERT INTO users_credentials (email, UserPassword) VALUES (%s, %s)", (email, password))
        mysql.connection.commit()

        # Close the database connection
        cur.close()

        # Redirect the user to the login page after successful signup
        

        return redirect('/')

    # If the request method is GET, render the signup template
    return render_template('signup.html')

@app.route('/logout')
def logout():
    # Clear user's session data
    session.pop('email', None)
    session.pop('admin', False)
    session.pop('user', False)

    # Redirect user to login page
    return redirect('/')

# @app.route('/dbmsuser', methods=['GET', 'POST'])
# def dbms():
#     if request.method == 'POST':
#         # Fetch form data
#         userDetails = request.form
#         book_name = userDetails['name']
#         cur = mysql.connection.cursor()
#         resultValue = cur.execute("select * from book where title = '" + book_name + "';")  #LIKE '" + name + "%';
#         if resultValue > 0:
#             temp = cur.fetchall()
#             return render_template('books.html', rows = temp)
#         mysql.connection.commit()
#         cur.close()
#         return 'not'
#     return render_template('dbmsuser.html')


@app.route('/dbmsuser', methods=['GET', 'POST'])
def dbms():
    # Check if user is logged in
    if 'email' not in session:
        return redirect('/')
    
    if request.method == 'POST':
    # Fetch form data
        search_type = request.form['search_type']
        search_query = request.form['search_query']
        cur = mysql.connection.cursor()
        if search_type == 'title':
            resultValue = cur.execute("SELECT * FROM book WHERE title LIKE '%" + search_query + "%';")
        elif search_type == 'book_id':
            resultValue = cur.execute("SELECT * FROM book WHERE book_id = %s;", (search_query,))
        elif search_type == 'author_id':
            resultValue = cur.execute("SELECT * FROM book WHERE author_id = %s;", (search_query,))
        if resultValue > 0:
            temp = cur.fetchall()
            return render_template('books.html', rows=temp)
        mysql.connection.commit()
        cur.close()
        return render_template('no_result.html')
        #return 'No Result Found!!!'
    return render_template('dbmsuser.html')


@app.route('/DBMS', methods=['GET', 'POST'])
def index():
     # Check if user is logged in
    if 'email' not in session:
        return redirect('/')
    
    if request.method == 'POST':
        # Fetch form data
        userDetails = request.form
        book_name = userDetails['name']
        cur = mysql.connection.cursor()
        resultValue = cur.execute("select * from book where title = '" + book_name + "';")  #LIKE '" + name + "%';
        if resultValue > 0:
            temp = cur.fetchall()
            return render_template('admin.html', rows = temp)
        mysql.connection.commit()
        cur.close()
        return 'not'
    return render_template('DBMS.html')

@app.route('/books', methods =['GET', 'POST'])
def book():
    if request.method == 'GET':
        cur  = mysql.connection.cursor()
        resultvalue = cur.execute("SELECT * from book")
        if(resultvalue > 0):
            userDetails =  cur.fetchall()
        return render_template('users.html',  userDetails = userDetails)

@app.route('/books_admin', methods =['GET', 'POST'])
def book_admin():
    if request.method == 'GET':
        cur  = mysql.connection.cursor()
        resultvalue = cur.execute("SELECT * from book")
        if(resultvalue > 0):
            userDetails =  cur.fetchall()
        return render_template('admin.html',  userDetails = userDetails)


@app.route('/issue', methods=['GET', 'POST'])
def issue():
    if request.method == 'POST':
        # Retrieve the user input from the form
        book_id= request.form['book_id']
        # Retrieve the user's email from the session
        email = session.get('email')

        # Open a database connection
        cur = mysql.connection.cursor()
        # Check if the book available or not
        cur.execute("SELECT * FROM book WHERE book_id = %s AND copies > 0", [book_id])
        b = cur.fetchone()

        if b is None:
            flash('Book is not available.', 'error')
            return redirect('/issue')
        # Get the current date and time and format it as a string
        issue_date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        cur.execute("INSERT INTO book_issue (book_id, email,issue_date) VALUES (%s, %s,%s)", (book_id,  email,issue_date))
        mysql.connection.commit()

         # Update the available copies in the book table
        cur.execute("UPDATE book SET copies = copies - 1 WHERE book_id = %s", (book_id,))
        mysql.connection.commit()

        flash('Book issued successfully.', 'success')
        sleep(2)
        return redirect('/dbmsuser')
    return render_template('issue.html')


@app.route('/libuser', methods=['GET', 'POST'])
def user():
    if request.method == 'GET':
        cur = mysql.connection.cursor()
        resultvalue = cur.execute("SELECT * from users")
        if resultvalue > 0:
            userDetails = cur.fetchall()
            return render_template('libuser.html', userDetails=userDetails)
        else:
            return "No users found."
    return render_template('libuser.html')

@app.route('/rename', methods=['GET', 'POST'])
def rename():
    if request.method == 'POST':
        userDetails = request.form
        old_col_name = userDetails['old_col_name']
        new_col_name = userDetails['new_col_name']
        cur = mysql.connection.cursor()
        cur.execute("ALTER TABLE `users` RENAME COLUMN `old_col_name` TO `new_col_name`;", [])
        mysql.connection.commit()
        cur.close()
        render_template('libuser.html')
        return redirect('/libuser')
    return render_template('rename.html')


@app.route('/add', methods=['GET', 'POST'])
def add():
    if request.method == 'POST':
        userDetails = request.form
        book_id = userDetails['book_id']
        title = userDetails['title']
        edition = userDetails['edition']
        copies = userDetails['copies']
        Availability_status = userDetails['Availability_status']
        author_id = userDetails['author_id']
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO book(book_id, title, edition, copies, Availability_status, author_id) VALUES(%s,%s,%s,%s,%s,%s)", (book_id, title, edition, copies, Availability_status, author_id))
        mysql.connection.commit()
        cur.close()
        return redirect('/DBMS')
    return render_template('add.html')

@app.route('/delete', methods=['POST', 'GET'])
def delete():
    if request.method == 'POST':
        userDetails = request.form
        book_id = userDetails['book_id']

        cur = mysql.connection.cursor()
        cur.execute("DELETE FROM book WHERE book_id = %s", [book_id])
        mysql.connection.commit()
        cur.close()
        return redirect("/DBMS")
    return render_template('delete.html')

@app.route('/updateuser', methods=['POST', 'GET'])
def update_user():
    if request.method == 'POST':
        userDetails = request.form
        UserID = userDetails['UserID']
        Contact = userDetails['Contact']
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE UserID = %s", [UserID])
        user = cur.fetchone()

        if user:
            cur.execute("UPDATE users SET Contact = %s WHERE UserID = %s", [Contact, UserID])
            mysql.connection.commit()
            cur.close()
            flash('User updated successfully!', 'success')
            return redirect("/libuser")
        else:
            flash('User ID not found!', 'error')
            return redirect("/updateuser")

    return render_template('updateuser.html')


@app.route('/authors')
def authors():
    cur  = mysql.connection.cursor()
    resultvalue = cur.execute("SELECT * from author")
    if(resultvalue > 0):
        userDetails =  cur.fetchall()
    return render_template('authors.html',  userDetails = userDetails)


if __name__ == '__main__':
    app.run(debug=True)

