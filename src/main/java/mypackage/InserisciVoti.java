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

@WebServlet("/InserisciVoti")
public class InserisciVoti extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idAppello = request.getParameter("idAppello");

        String[] matricole = request.getParameterValues("matricola");
        String[] voti = request.getParameterValues("voto");

        Connection conn = Connessione.getCon();

        try {
            // Controlla che i dati siano validi
            if (matricole != null && voti != null && matricole.length == voti.length) {

                PreparedStatement stmt = conn.prepareStatement(
                    "INSERT INTO voto (studente_id, appello_id, voto) VALUES (?, ?, ?)"
                );

                for (int i = 0; i < matricole.length; i++) {
                    String matricola = matricole[i];
                    String votoStr = voti[i];

                    if (matricola == null || votoStr == null || votoStr.isEmpty()) {
                        continue; // salta valori vuoti
                    }

                    stmt.setString(1, matricola);
                    stmt.setString(2, idAppello);
                    stmt.setString(3, votoStr);
                    stmt.addBatch();
                }

                stmt.executeBatch(); // esegue tutti i voti

                request.setAttribute("success", "✅ Voti salvati con successo!");
                RequestDispatcher rd = request.getRequestDispatcher("professore.jsp");
                rd.forward(request, response);

            } else {
                request.setAttribute("error", "❌ Nessun voto ricevuto o numero errato di campi.");
                RequestDispatcher rd = request.getRequestDispatcher("professore.jsp");
                rd.forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Errore durante l'inserimento dei voti");
            RequestDispatcher rd = request.getRequestDispatcher("professore.jsp");
            rd.forward(request, response);
        }
    }
}