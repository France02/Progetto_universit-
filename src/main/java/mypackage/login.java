package mypackage; // <--- Assicurati che questo sia il tuo pacchetto corretto!

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

@WebServlet("/login") // <--- Questa annotazione mappa questa Servlet all'URL /login
public class login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public login() {
        super();
    }

    // Gestisce le richieste GET, reindirizzando al form di login
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher("/index.jsp");
        rd.forward(request, response);
    }

    // Gestisce le richieste POST dal form di login
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");

        // Stampa di debug, utile per vedere i valori ricevuti
        System.out.println("Login attempt for username: " + username + ", userType: " + userType);

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ResultSet rsCorsi = null;

        try {
            // Assicurati che Connessione.getCon() sia implementato correttamente e restituisca una connessione valida
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

                    // Reindirizza alla Servlet che gestisce l'area professori e mostra gli studenti
                    // Assicurati che la Servlet "StampaStudenti" sia mappata a "/StampaStudenti"
                    System.out.println("Professore logged in. Redirecting to StampaStudenti.");
                    response.sendRedirect("StampaStudenti");
                    return; // Termina l'esecuzione dopo il reindirizzamento
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

                    // Chiudi il PreparedStatement e ResultSet precedenti prima di riutilizzare pstmt
                    try {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                    } catch (SQLException e) {
                        e.printStackTrace(); // Logga l'errore ma non bloccare il flusso
                    }

                    String sqlCorsi = "SELECT C.idCorso, C.Materia, P.nome AS nome_docente, P.cognome AS cognome_docente " +
                                      "FROM corso C JOIN professore P ON C.Cattedra = P.idProfessore";

                    pstmt = conn.prepareStatement(sqlCorsi);
                    rsCorsi = pstmt.executeQuery();
                    request.setAttribute("tabella_corso", rsCorsi);

                    // Forward alla pagina studente.jsp
                    System.out.println("Studente logged in. Forwarding to studente.jsp.");
                    RequestDispatcher rd = request.getRequestDispatcher("/studente.jsp");
                    rd.forward(request, response);
                    return; // Termina l'esecuzione dopo il forward
                }
            }

            // Se il login fallisce per professore o studente
            System.out.println("Login failed for username: " + username);
            request.setAttribute("messaggioErrore", "Username o password non validi.");
            RequestDispatcher rd = request.getRequestDispatcher("/index.jsp");
            rd.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace(); // Stampa l'errore SQL sulla console del server
            System.err.println("Database error during login: " + e.getMessage());
            request.setAttribute("messaggioErrore", "Errore di database durante il login: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("/index.jsp");
            rd.forward(request, response);
        } finally {
            // Assicurati di chiudere tutte le risorse del database in un blocco finally
            try {
                if (rs != null) rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (rsCorsi != null) rsCorsi.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}