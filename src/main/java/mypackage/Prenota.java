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

@WebServlet("/Prenota") 
public class Prenota extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public Prenota() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect("index.jsp"); 
        return;
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String idAppelloParam = request.getParameter("idAppello"); 
		String matricolaStudente = (String) session.getAttribute("matricolaStudente"); 

		if (matricolaStudente == null) {
			response.sendRedirect("index.jsp"); 
			return;
		}

		int idAppello = -1;
		if (idAppelloParam != null && !idAppelloParam.isEmpty()) {
			try {
				idAppello = Integer.parseInt(idAppelloParam);
			} catch (NumberFormatException e) {
				System.err.println("Errore: ID Appello non valido: " + idAppelloParam);
				request.setAttribute("messaggioPrenotazione", "Errore: ID Appello non valido per la prenotazione.");
                // Anche qui, dobbiamo passare idCorso per far funzionare il reindirizzamento
                // Questo idCorso sarà -1, quindi Prenotazione mostrerà solo i corsi senza appelli
				RequestDispatcher rd = request.getRequestDispatcher("Prenotazione"); 
				rd.forward(request, response);
				return;
			}
		} else {
			request.setAttribute("messaggioPrenotazione", "Errore: ID Appello non fornito per la prenotazione.");
            // Anche qui, dobbiamo passare idCorso per far funzionare il reindirizzamento
            // Questo idCorso sarà -1, quindi Prenotazione mostrerà solo i corsi senza appelli
			RequestDispatcher rd = request.getRequestDispatcher("Prenotazione");
			rd.forward(request, response);
			return;
		}
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; 
        
        int idCorsoAssociato = -1; // Variabile per salvare l'ID del corso associato all'appello

		try {
			conn = Connessione.getCon(); 

            // PRIMA DI TUTTO: Recupera l'idCorso dall'appello per passarlo a Prenotazione.java
            String sqlGetIdCorso = "SELECT Materia FROM appello WHERE idAppello = ?";
            pstmt = conn.prepareStatement(sqlGetIdCorso);
            pstmt.setInt(1, idAppello);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                idCorsoAssociato = rs.getInt("Materia"); // La colonna Materia in appello è l'idCorso
            }
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();

            // Se l'ID del corso non è stato trovato, gestisci l'errore
            if (idCorsoAssociato == -1) {
                request.setAttribute("messaggioPrenotazione", "Errore: Corso associato all'appello non trovato.");
                // Faccio comunque il forward a Prenotazione per ricaricare la pagina
                // senza appelli, ma con messaggio. Non possiamo passare un idCorso valido.
                RequestDispatcher rd = request.getRequestDispatcher("Prenotazione");
                rd.forward(request, response);
                return;
            }

            // Imposta l'idCorso come parametro della REQUEST per il forward successivo
            // Questo è FONDAMENTALE per far funzionare Prenotazione.java dopo il forward
            request.setAttribute("idCorso", String.valueOf(idCorsoAssociato)); // Prenotazione si aspetta una Stringa per idCorsoParam


			// 1. Verifica se lo studente è già iscritto a questo appello
			String sqlCheck = "SELECT COUNT(*) FROM prenotazione WHERE stud_prenotato = ? AND app_prenotato = ?";
			pstmt = conn.prepareStatement(sqlCheck);
			pstmt.setString(1, matricolaStudente); 
			pstmt.setInt(2, idAppello); 
			rs = pstmt.executeQuery();
			if (rs.next() && rs.getInt(1) > 0) {
				request.setAttribute("messaggioPrenotazione", "Sei già iscritto a questo appello.");
                // Qui, dato che idCorsoAssociato è già stato recuperato, lo passiamo
                request.setAttribute("idCorso", String.valueOf(idCorsoAssociato));
				RequestDispatcher rd = request.getRequestDispatcher("Prenotazione"); 
				rd.forward(request, response);
				return;
			}
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close(); 

			// 2. Inserisci la nuova prenotazione nella tabella 'prenotazione'
			String sqlInsert = "INSERT INTO prenotazione (stud_prenotato, app_prenotato) VALUES (?, ?)";
			pstmt = conn.prepareStatement(sqlInsert);
			pstmt.setString(1, matricolaStudente);
			pstmt.setInt(2, idAppello);
			
			int rowsAffected = pstmt.executeUpdate();
			
			if (rowsAffected > 0) {
				request.setAttribute("messaggioPrenotazione", "Prenotazione effettuata con successo per l'appello " + idAppello + "!");
			} else {
				request.setAttribute("messaggioPrenotazione", "Errore: Impossibile effettuare la prenotazione.");
			}
			
			// 3. Reindirizza al servlet Prenotazione, passando l'ID del corso
            // request.setAttribute("idCorso", String.valueOf(idCorsoAssociato)); // Già fatto sopra
			RequestDispatcher rd = request.getRequestDispatcher("Prenotazione"); 
			rd.forward(request, response);

		} catch (SQLException e) {
			e.printStackTrace();
			if (e.getErrorCode() == 1062) { 
				request.setAttribute("messaggioPrenotazione", "Sei già iscritto a questo appello.");
			} else {
				request.setAttribute("messaggioPrenotazione", "Errore di database durante la prenotazione: " + e.getMessage());
			}
            // In caso di errore, cerca comunque di ricaricare la pagina con l'idCorso se disponibile
            if (idCorsoAssociato != -1) {
                request.setAttribute("idCorso", String.valueOf(idCorsoAssociato));
            }
			RequestDispatcher rd = request.getRequestDispatcher("Prenotazione"); 
			rd.forward(request, response);
		} finally {
			try {
				if (rs != null) rs.close(); 
				if (pstmt != null) pstmt.close(); 
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}
