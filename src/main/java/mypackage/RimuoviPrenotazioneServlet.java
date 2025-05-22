package mypackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/RimuoviPrenotazioneServlet")
public class RimuoviPrenotazioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public RimuoviPrenotazioneServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("professore.jsp"); // Impedisci accesso diretto
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String matricolaProfessore = (String) session.getAttribute("matricolaProfessore");

        if (matricolaProfessore == null) {
            response.sendRedirect("index.jsp"); // Utente non autenticato
            return;
        }

        String idPrenotazioneParam = request.getParameter("idPrenotazione"); // Questo è idpren
        String idAppelloParam = request.getParameter("idAppello"); // L'appello da cui stiamo rimuovendo

        int idPrenotazione = -1;
        int idAppello = -1;

        if (idPrenotazioneParam != null && !idPrenotazioneParam.isEmpty()) {
            try {
                idPrenotazione = Integer.parseInt(idPrenotazioneParam);
                System.out.println("RimuoviPrenotazioneServlet: Tentativo di rimuovere prenotazione con idpren: " + idPrenotazione);
            } catch (NumberFormatException e) {
                System.err.println("RimuoviPrenotazioneServlet: ID Prenotazione non valido: " + idPrenotazioneParam);
                request.setAttribute("messaggioProfessore", "ID Prenotazione non valido per la rimozione.");
            }
        } else {
            request.setAttribute("messaggioProfessore", "Nessun ID Prenotazione fornito per la rimozione.");
        }

        // Recupera l'idAppello per poter ricaricare correttamente la lista degli studenti in GestisciAppelloServlet
        if (idAppelloParam != null && !idAppelloParam.isEmpty()) {
            try {
                idAppello = Integer.parseInt(idAppelloParam);
            } catch (NumberFormatException e) {
                System.err.println("RimuoviPrenotazioneServlet: ID Appello non valido: " + idAppelloParam);
                // Non impostiamo un messaggioProfessore qui, perché vogliamo che venga sovrascritto
                // se la rimozione ha successo o fallisce in altro modo.
            }
        }


        Connection conn = null;
        PreparedStatement pstmt = null;

        if (idPrenotazione != -1) {
            try {
                conn = Connessione.getCon();
                String sql = "DELETE FROM prenotazione WHERE idpren = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, idPrenotazione);

                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    request.setAttribute("messaggioProfessore", "Prenotazione rimossa con successo!");
                } else {
                    request.setAttribute("messaggioProfessore", "Errore: Prenotazione non trovata o impossibile rimuovere.");
                }

            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("messaggioProfessore", "Errore di database durante la rimozione della prenotazione: " + e.getMessage());
            } finally {
                try {
                    if (pstmt != null) pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        // Dopo aver rimosso, dobbiamo tornare alla vista di gestione dell'appello.
        // Inoltriamo la richiesta a GestisciAppelloServlet per ricaricare i dati aggiornati.
        // Passiamo l'idAppello come ATTRIBUTO, perché GestisciAppelloServlet lo legge anche come attributo.
        request.setAttribute("idAppello", String.valueOf(idAppello)); // NOTA: GestisciAppelloServlet si aspetta una String per idCorsoParam, ma anche un Object per idCorsoAttr
        RequestDispatcher rd = request.getRequestDispatcher("/GestisciAppelloServlet"); 
        rd.forward(request, response);
    }
}