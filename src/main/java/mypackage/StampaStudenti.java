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

@WebServlet("/StampaStudenti")
public class StampaStudenti extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public StampaStudenti() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String matricolaProfessoreString = (String) session.getAttribute("matricolaProfessore");

        if (matricolaProfessoreString == null) {
            response.sendRedirect("index.jsp"); 
            return;
        }

        Connection conn = null;
        PreparedStatement pstmtAppelli = null;
        PreparedStatement pstmtStudenti = null;
        ResultSet rsAppelli = null;
        ResultSet rsStudenti = null;

        try {
            conn = Connessione.getCon(); 

            int matricolaProfessore = Integer.parseInt(matricolaProfessoreString);

            String sqlAppelli = "SELECT A.idAppello, A.Data, C.Materia AS NomeMateriaCorso " + 
                                "FROM appello A JOIN corso C ON A.Materia = C.idCorso " +
                                "WHERE C.Cattedra = ?"; 
            pstmtAppelli = conn.prepareStatement(sqlAppelli);
            pstmtAppelli.setInt(1, matricolaProfessore); 
            rsAppelli = pstmtAppelli.executeQuery();
            request.setAttribute("elenco_appelli_prof", rsAppelli);

            String sqlStudenti = "SELECT matricola, nome, cognome FROM studente";
            pstmtStudenti = conn.prepareStatement(sqlStudenti);
            rsStudenti = pstmtStudenti.executeQuery();
            request.setAttribute("elenco_studenti", rsStudenti);

            RequestDispatcher rd = request.getRequestDispatcher("professore.jsp");
            rd.forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("messaggioProfessore", "Errore interno: ID professore non valido.");
            RequestDispatcher rd = request.getRequestDispatcher("professore.jsp");
            rd.forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace(); 
            request.setAttribute("messaggioProfessore", "Errore di database: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("professore.jsp"); 
            rd.forward(request, response);
        } finally {
            try {
            } catch (Exception e) { 
                e.printStackTrace();
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response); 
    }
}