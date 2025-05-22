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

/**
 * Servlet implementation class InserisciVoti
 */
@WebServlet("/InserisciVoti")
public class InserisciVoti extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public InserisciVoti() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Non usiamo GET → puoi reindirizzare a doPost o mostrare errore
        response.getWriter().append("GET non supportato");
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String idAppello = request.getParameter("idAppello");
        
        // Supponiamo di ricevere matricole e voti come array dal form
        String[] matricole = request.getParameterValues("matricola");
        String[] voti = request.getParameterValues("voto");

        Connection conn = Connessione.getCon();

        try {
            if (matricole != null && voti != null && matricole.length == voti.length) {

                String sql = "INSERT INTO voto (studente_id, appello_id, voto) VALUES (?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);

                for (int i = 0; i < matricole.length; i++) {
                    String matricola = matricole[i];
                    String voto = voti[i];

                    // Salta valori nulli o vuoti
                    if (matricola == null || matricola.isEmpty() || voto == null || voto.isEmpty()) {
                        continue;
                    }

                    stmt.setString(1, matricola);
                    stmt.setString(2, idAppello);
                    stmt.setString(3, voto);
                    stmt.addBatch(); // Aggiungi alla batch
                }

                stmt.executeBatch(); // Esegui tutti i comandi

                // Reindirizza con messaggio di successo
                request.setAttribute("success", "✅ Voti inseriti correttamente.");
                RequestDispatcher rd = request.getRequestDispatcher("professore.jsp");
                rd.forward(request, response);

            } else {
                request.setAttribute("error", "❌ Nessun voto ricevuto o dati errati.");
                RequestDispatcher rd = request.getRequestDispatcher("professore.jsp");
                rd.forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            
        }
    }
}