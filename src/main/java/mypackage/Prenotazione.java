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


@WebServlet("/Prenotazione")
public class Prenotazione extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public Prenotazione() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect("index.jsp"); 
        return;
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// --- MODIFICA QUI: Inizializza idCorsoParam e idCorso ---
		String idCorsoParam = null;
		int idCorso = -1;

		// 1. Prova a leggere idCorso come attributo della richiesta (se passato da un altro Servlet come Prenota.java)
        Object idCorsoAttr = request.getAttribute("idCorso");
        if (idCorsoAttr != null) {
            idCorsoParam = idCorsoAttr.toString(); // Converte l'attributo in String
        } else {
            // 2. Se non è un attributo, prova a leggerlo come parametro (se inviato da un form)
            idCorsoParam = request.getParameter("idCorso"); 
        }
		// --- FINE MODIFICA ---

		HttpSession session = request.getSession();
        String matricolaStud = (String) session.getAttribute("matricolaStudente");

        if (matricolaStud == null) {
            response.sendRedirect("index.jsp"); 
            return;
        }

		if (idCorsoParam != null && !idCorsoParam.isEmpty()) {
			try {
				idCorso = Integer.parseInt(idCorsoParam);
			} catch (NumberFormatException e) {
				System.out.println("Errore: ID Corso non valido: " + idCorsoParam);
				request.setAttribute("messaggioStudente", "Errore: ID Corso non valido.");
			}
		} else {
			request.setAttribute("messaggioStudente", "Errore: ID Corso non fornito.");
            // Non fare 'return' qui, vogliamo comunque caricare la tabella corsi
		}
		
		Connection conn = null;
		PreparedStatement pstmtNomeMateria = null;
		PreparedStatement pstmtAppelli = null;
		PreparedStatement pstmtCorsi = null; 
		ResultSet rsNomeMateria = null;

		String nomeMateria = null; 

		try {
			conn = Connessione.getCon(); 

			// 1. Recupera il nome della materia (stringa) dall'ID del corso
			// Esegui questa parte solo se idCorso è valido
			if (idCorso != -1) { 
				String sqlNomeMateria = "SELECT Materia FROM corso WHERE idCorso = ?";
				pstmtNomeMateria = conn.prepareStatement(sqlNomeMateria);
				pstmtNomeMateria.setInt(1, idCorso);
				rsNomeMateria = pstmtNomeMateria.executeQuery();
				
				if (rsNomeMateria.next()) {
					nomeMateria = rsNomeMateria.getString("Materia"); 
					request.setAttribute("materia", nomeMateria); 
				} else {
					request.setAttribute("messaggioStudente", "Corso selezionato non trovato.");
				}
			}

			// 2. Recupera gli appelli usando l'ID del corso (che è nella colonna Materia della tabella appello)
			// Esegui questa parte solo se idCorso è valido
			if (idCorso != -1) { 
				String sqlAppelli = "SELECT A.idAppello, A.Data, C.Materia AS NomeMateriaAssoc " + 
									"FROM appello A JOIN corso C ON A.Materia = C.idCorso " +
									"WHERE C.idCorso = ?"; 
				
				pstmtAppelli = conn.prepareStatement(sqlAppelli);
				pstmtAppelli.setInt(1, idCorso); 
				ResultSet rsAppelli = pstmtAppelli.executeQuery(); 
				request.setAttribute("elenco_appelli", rsAppelli); 
			}

            // 3. Ricarica sempre la tabella dei corsi per lo studente
            pstmtCorsi = conn.prepareStatement( 
                "SELECT C.idCorso, C.Materia, P.nome AS nome_docente, P.cognome AS cognome_docente " +
                "FROM corso C JOIN professore P ON C.Cattedra = P.idProfessore"
            );
            ResultSet rsCorsi = pstmtCorsi.executeQuery(); 
            request.setAttribute("tabella_corso", rsCorsi);
            
            // Forward alla JSP
			RequestDispatcher rd = request.getRequestDispatcher("studente.jsp");
			rd.forward(request, response);

		} catch (SQLException e) {
			e.printStackTrace();
			request.setAttribute("messaggioStudente", "Errore di database: " + e.getMessage());
            // In caso di errore SQL, si può reindirizzare al login o alla pagina principale
            response.sendRedirect("index.jsp"); 
		} finally {
			try {
				if (rsNomeMateria != null) rsNomeMateria.close();
				if (pstmtNomeMateria != null) pstmtNomeMateria.close();
				// pstmtAppelli e pstmtCorsi non vengono chiusi qui perché i loro ResultSet sono passati alla JSP.
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}