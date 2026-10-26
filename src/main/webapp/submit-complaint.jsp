
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Complaint | CampusCare</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            color: #1f2937;
        }
        header {
            background: #173b70;
            color: white;
            padding: 20px 8%;
        }
        main {
            max-width: 650px;
            margin: 40px auto;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,.08);
        }
        h1 { color: #173b70; }
        label {
            display: block;
            margin: 18px 0 7px;
            font-weight: bold;
        }
        input, select, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            box-sizing: border-box;
            font: inherit;
        }
        textarea { min-height: 150px; resize: vertical; }
        button {
            margin-top: 22px;
            padding: 13px 20px;
            background: #173b70;
            color: white;
            border: 0;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
        }
        .error {
            padding: 12px;
            background: #fee2e2;
            color: #991b1b;
            border-radius: 6px;
        }
        a { color: #173b70; }
    </style>
</head>
<body>
<header><strong>CampusCare — Submit Complaint</strong></header>

<main>
    <h1>Submit a Complaint</h1>
    <p>Describe the campus issue clearly so it can be reviewed.</p>

    <% if ("empty".equals(error)) { %>
        <p class="error">Please complete all fields.</p>
    <% } else if ("length".equals(error)) { %>
        <p class="error">One or more fields exceed the permitted length.</p>
    <% } %>

    <form action="submit-complaint" method="post">
        <label for="title">Complaint title</label>
        <input type="text" id="title" name="title"
               maxlength="150" required>

        <label for="category">Category</label>
        <select id="category" name="category" required>
            <option value="">Select a category</option>
            <option value="Hostel">Hostel</option>
            <option value="Academic">Academic</option>
            <option value="Infrastructure">Infrastructure</option>
            <option value="Cleanliness">Cleanliness</option>
            <option value="Electricity">Electricity</option>
            <option value="Water">Water</option>
            <option value="IT Services">IT Services</option>
            <option value="Other">Other</option>
        </select>

        <label for="description">Complaint description</label>
        <textarea id="description" name="description"
                  maxlength="5000" required></textarea>

        <button type="submit">Submit Complaint</button>
    </form>

    <p><a href="dashboard.jsp">Back to Dashboard</a></p>
</main>
</body>
</html>
