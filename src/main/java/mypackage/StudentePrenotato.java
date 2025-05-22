package mypackage;

// Questa classe rappresenta uno studente prenotato per un appello
// Include anche l'ID della prenotazione specifica (idpren)
public class StudentePrenotato {
    private String matricola;
    private String nome;
    private String cognome;
    private int idPrenotazione; // Campo 'idpren' dalla tabella 'prenotazione'

    public StudentePrenotato(String matricola, String nome, String cognome, int idPrenotazione) {
        this.matricola = matricola;
        this.nome = nome;
        this.cognome = cognome;
        this.idPrenotazione = idPrenotazione;
    }

    // Getter per accedere ai dati
    public String getMatricola() {
        return matricola;
    }

    public String getNome() {
        return nome;
    }

    public String getCognome() {
        return cognome;
    }

    public int getIdPrenotazione() {
        return idPrenotazione;
    }
}