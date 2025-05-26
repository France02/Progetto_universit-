package mypackage;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/Modifica")
public class Modifica extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    public Modifica() {
        super();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("index.jsp"); 
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
      	Connection conn = Connessione.getCon();
        response.setContentType("text/html;charset=UTF-8");
		HttpSession session = request.getSession();
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String matricola = (String) session.getAttribute("matricolaStudente");
        PreparedStatement ps = null;
        try {
			ps =conn.prepareStatement("UPDATE studente SET username = ?, password = ? WHERE Matricola=?");
			ps.setString(1, username);
			ps.setString(2,password);
			ps.setString(3, matricola); 
			ps.executeUpdate(); 
			ps.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        RequestDispatcher rd = request.getRequestDispatcher("/studente.jsp");
        rd.forward(request, response);
        }
    }
