# OracleReportAI

Automaattinen liiketoimintaraporttien generointi Oracle Database 26ai + Python + Claude AI -stackilla.

Projekti generoi ihmisluettavan HTML-raportin suoraan tietokannasta — ilman manuaalista työtä.

![Stack](https://img.shields.io/badge/Oracle-26ai-red) ![Python](https://img.shields.io/badge/Python-3.14-blue) ![Claude](https://img.shields.io/badge/Claude-Sonnet-green)

---

## Arkkitehtuuri

Oracle DB (myyntidata)
↓
PL/SQL (aggregoi datan yhteenvedoksi)
↓
Python (lukee DB:stä, kutsuu Claude APIa)
↓
Claude API (kirjoittaa narratiivin datasta)
↓
HTML-raportti (valmis output)

## Teknologiapino

| Komponentti | Teknologia |
|-------------|-----------|
| Tietokanta | Oracle AI Database 26ai Free (Docker) |
| Logiikka | PL/SQL |
| Backend | Python 3.14 |
| AI | Claude API (claude-sonnet) |
| Output | HTML-raportti |
| Versionhallinta | GitHub |

---

## Asennus

### 1. Vaatimukset
- Docker Desktop
- Python 3.10+
- Anthropic API-avain

### 2. Kloonaa repo

```bash
git clone https://github.com/KÄYTTÄJÄNIMI/OracleReportAI.git
cd OracleReportAI
```

### 3. Python-ympäristö

```bash
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

### 4. Ympäristömuuttujat

Luo `.env` tiedosto:

```env
ORACLE_USER=system
ORACLE_PASSWORD=OracleReportAI1
ORACLE_DSN=localhost:1521/FREE
ANTHROPIC_API_KEY=sk-ant-...
```

### 5. Oracle Docker

```bash
docker run -d \
  --name oracle26ai \
  -p 1521:1521 \
  -e ORACLE_PWD=OracleReportAI1 \
  container-registry.oracle.com/database/free:latest
```

Odota `DATABASE IS READY TO USE!`

### 6. Tietokanta

```bash
docker cp db/schema.sql oracle26ai:/tmp/schema.sql
docker exec -it oracle26ai bash -c "sqlplus system/OracleReportAI1@FREE @/tmp/schema.sql"

docker cp db/report_proc.sql oracle26ai:/tmp/report_proc.sql
docker exec -it oracle26ai bash -c "sqlplus system/OracleReportAI1@FREE @/tmp/report_proc.sql"

docker cp db/report_body.sql oracle26ai:/tmp/report_body.sql
docker exec -it oracle26ai bash -c "sqlplus system/OracleReportAI1@FREE @/tmp/report_body.sql"
```

---

## Käyttö

```bash
python src/main.py
```

Raportti generoituu kansioon `output/raportti_2025.html`

---

## Esimerkkioutput

Raportti sisältää:
- Kokonaismyynti ja myyntitapahtumien määrä
- Kvartaalikohtainen myyntidata (Q1–Q4)
- Paras tuote ja paras asiakas
- Claude AI:n generoima johdon katsaus

---

## Kehittäjä

**Elias Martikainen** — [Eldarisoft](https://eldarisoft.fi)