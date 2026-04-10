# OracleReportAI

Automaattinen liiketoimintaraporttien generointi Oracle Database 26ai + Python + Claude AI -stackilla.

Projekti generoi ihmisluettavan HTML-raportin suoraan tietokannasta — ilman manuaalista työtä.

![Stack](https://img.shields.io/badge/Oracle-26ai-red) ![Python](https://img.shields.io/badge/Python-3.14-blue) ![Claude](https://img.shields.io/badge/Claude-Sonnet-green)

---

## Arkkitehtuuri

```text
Oracle DB (myyntidata)
    ↓
PL/SQL (aggregoi datan yhteenvedoksi)
    ↓
Python (lukee DB:stä, kutsuu Claude APIa)
    ↓
Claude API (kirjoittaa narratiivin datasta)
    ↓
HTML-raportti (valmis output)
```

---

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

## Esimerkkiskenaario — Jankon Betoni Oy

Tässä esimerkissä OracleReportAI generoi vuosiraportin **Jankon Betoni Oy:lle** —
tamperelaiselle betonituotteiden toimittajalle, joka on ollut toiminnassa vuodesta 1987.

![Jankon Betoni Raportti](screenshots/jankos_beton.png)


### Tietokannassa oleva myyntidata

Tietokanta sisältää 5 asiakasta, 5 tuotetta ja 16 myyntitapahtumaa vuodelta 2025.

**Tuotteet:**

| Tuote | Kategoria | Á-hinta |
|-------|-----------|---------|
| Jankon Erikoisbetoni K30 | Betoni | 320 € |
| Peruspilkkabetoni K20 | Betoni | 180 € |
| Betonipumppaus Premium | Palvelut | 1 200 € |
| Jankon Salainen Lisäaine | Lisäaineet | 450 € |
| Hätäbetoni (24h toimitus) | Betoni | 580 € |

**Asiakkaat:**

| Asiakas | Kaupunki | Segmentti |
|---------|----------|-----------|
| Heikki Valimaki Ky | Tampere | Yritys |
| Pentti Kukkonen | Hämeenlinna | Kuluttaja |
| Möttösen Rakennus Oy | Jyväskylä | Yritys |
| Reijo Paasonen | Tampere | Kuluttaja |
| Hirmuinen Oy | Helsinki | Yritys |

### Mitä tapahtuu kun ajat `python src/main.py`

**1. Python kutsuu Oracle-tietokantaa**

PL/SQL-proseduuri `report_pkg.get_vuosiraportti(2025)` aggregoi myyntidatan
ja palauttaa JSON-yhteenvedon:

```json
{
  "vuosi": 2025,
  "kokonaismyynti": 41270,
  "myyntikpl": 16,
  "paras_tuote": "Jankon Erikoisbetoni K30",
  "paras_asiakas": "Heikki Valimaki Ky",
  "q1": 7850,
  "q2": 11360,
  "q3": 12260,
  "q4": 9800
}
```

**2. Python lähettää datan Claude API:lle**

Claude saa datan ja kirjoittaa johdon katsauksen automaattisesti.

**3. Claude generoi narratiivin**

> *Jankon Betoni Oy saavutti vuonna 2025 kokonaismyynnin 41 270 euroa
> 16 myyntitapahtuman kautta. Keskimääräinen kauppakoko oli 2 579 euroa,
> mikä kuvastaa yhtiön keskittymistä laadukkaaseen betonituotantoon ja
> pitkäaikaisiin asiakassuhteisiin.*
>
> *Kvartaalikohtainen tarkastelu osoittaa selkeää kasvutrendiä vuoden
> alkupuoliskolla. Q1:n 7 850 euron myynti kasvoi Q2:ssa 44,7 % tasolle
> 11 360 euroa. Q3 oli vuoden vahvin 12 260 eurolla, mutta Q4:ssä myynti
> laski 20,1 % tasolle 9 800 euroa — heijastellen rakennusalan
> kausivaihtelua ja talvikauden vaikutusta betonityömaiden aktiivisuuteen.*
>
> *Tuoteportfoliossa Jankon Erikoisbetoni K30 vahvisti asemansa yhtiön
> menestystuotteena. Asiakaspuolella Heikki Valimaki Ky säilytti asemansa
> merkittävimpänä asiakkaana, osoittaen pitkäaikaisten kumppanuussuhteiden
> arvon yhtiön liiketoiminnalle.*
>
> *Vuoden 2026 näkymät ovat maltillisen optimistiset, erityisesti kun
> huomioidaan Jankon Erikoisbetoni K30:n vahva markkina-asema ja
> vakiintuneet asiakassuhteet.*

**4. Valmis HTML-raportti tallentuu** kansioon `output/raportti_2025.html`

> Koko pipeline — tietokantakysely, AI-analyysi ja raportin generointi —
> suoritetaan yhdellä komennolla alle 15 sekunnissa.

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

## Kehittäjä

**Elias Martikainen** — [Eldarisoft](https://eldarisoft.fi)
