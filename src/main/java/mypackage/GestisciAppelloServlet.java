package mypackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/GestisciAppelloServlet")
public class GestisciAppelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public GestisciAppelloServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Reindirizza alla pagina del professore se si tenta un accesso diretto con GET
        response.sendRedirect("professore.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String matricolaProfessore = (String) session.getAttribute("matricolaProfessore");

        if (matricolaProfessore == null) {
            response.sendRedirect("index.jsp"); // Utente non autenticato, reindirizza al login
            return;
        }

        String idAppelloParam = request.getParameter("idAppello");
        int idAppello = -1;

        if (idAppelloParam != null && !idAppelloParam.isEmpty()) {
            try {
                idAppello = Integer.parseInt(idAppelloParam);
                System.out.println("GestisciAppelloServlet: Ricevuto idAppello per gestione: " + idAppello);

                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                // Utilizziamo la classe StudentePrenotato ora separata
                List<StudentePrenotato> studentiPrenotati = new ArrayList<>();

                try {
                    conn = Connessione.getCon();
                    // Query per recuperare tutti gli studenti prenotati per un dato appello
                    String sql = "SELECT S.matricola, S.nome, S.cognome, P.idpren " +
                                 "FROM studente S JOIN prenotazione P ON S.matricola = P.stud_prenotato " +
                                 "WHERE P.app_prenotato = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, idAppello);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        studentiPrenotati.add(new StudentePrenotato(
                            rs.getString("matricola"),
                            rs.getString("nome"),
                            rs.getString("cognome"),
                            rs.getInt("idpren") // idpren della prenotazione
                        ));
                    }

                    request.setAttribute("idAppelloGestito", idAppello); // L'ID dell'appello che stiamo gestendo
                    request.setAttribute("studentiPrenotati", studentiPrenotati);

                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute("messaggioProfessore", "Errore di database durante il recupero degli studenti prenotati: " + e.getMessage());
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        // Non chiudere la connessione qui se Connessione.getCon() gestisce il pool
                        // o la chiusura automatica dopo il RequestDispatcher
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }

            } catch (NumberFormatException e) {
                System.err.println("GestisciAppelloServlet: ID Appello non valido: " + idAppelloParam);
                request.setAttribute("messaggioProfessore", "ID Appello non valido per la gestione.");
            }
        } else {
            request.setAttribute("messaggioProfessore", "Nessun ID Appello fornito per la gestione.");
        }

        // Reindirizza alla pagina del professore.
        // Questo dovrà essere un RequestDispatcher per mantenere gli attributi della request.
        RequestDispatcher rd = request.getRequestDispatcher("/StampaStudenti");
        rd.forward(request, response);
    }
}