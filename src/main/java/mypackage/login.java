package mypackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public login() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher("/index.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ResultSet rsCorsi = null; 

        try {
            conn = Connessione.getCon(); 

            if ("professore".equals(userType)) {
                String sqlProfessore = "SELECT idProfessore, nome, cognome FROM professore WHERE username = ? AND password = ?";
                pstmt = conn.prepareStatement(sqlProfessore);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("matricolaProfessore", rs.getString("idProfessore")); 
                    session.setAttribute("nomeProfessore", rs.getString("nome") + " " + rs.getString("cognome"));

                    response.sendRedirect("StampaStudenti");
                    return;
                }
            } else if ("studente".equals(userType)) {
                String sqlStudente = "SELECT matricola, nome, cognome FROM studente WHERE username = ? AND password = ?";
                pstmt = conn.prepareStatement(sqlStudente);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("matricolaStudente", rs.getString("matricola"));
                    session.setAttribute("nomeStudente", rs.getString("nome") + " " + rs.getString("cognome"));

                    if (pstmt != null) {
                        pstmt.close();
                        pstmt = null;
                    }
                    
                    String sqlCorsi = "SELECT C.idCorso, C.Materia, P.nome AS nome_docente, P.cognome AS cognome_docente " +
                                      "FROM corso C JOIN professore P ON C.Cattedra = P.idProfessore";
                    
                    pstmt = conn.prepareStatement(sqlCorsi);
                    rsCorsi = pstmt.executeQuery();
                    request.setAttribute("tabella_corso", rsCorsi);

                    RequestDispatcher rd = request.getRequestDispatcher("/studente.jsp");
                    rd.forward(request, response);
                    return;
                }
            }

            request.setAttribute("messaggioErrore", "Username o password non validi.");
            RequestDispatcher rd = request.getRequestDispatcher("/index.jsp");
            rd.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("messaggioErrore", "Errore di database durante il login: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("/index.jsp");
            rd.forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}