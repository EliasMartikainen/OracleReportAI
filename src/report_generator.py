import anthropic
import json
from dotenv import load_dotenv
import os

load_dotenv()

def generoi_narratiivi(data: dict) -> str:
    client = anthropic.Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))

    prompt = f"""Olet Jankon Betoni Oy:n talousanalyytikko. Kirjoita vuoden {data['vuosi']} 
myyntiraportti alla olevan datan pohjalta. Käytä vakavaa ja ammattimaista liiketoimintakieltä.
Mainitse tuotteiden nimet sellaisena kuin ne ovat.

DATA:
- Kokonaismyynti: {data['kokonaismyynti']} euroa
- Myyntitapahtumia: {data['myyntikpl']} kpl
- Paras tuote: {data['paras_tuote']}
- Paras asiakas: {data['paras_asiakas']}
- Q1 myynti: {data['q1']} euroa
- Q2 myynti: {data['q2']} euroa
- Q3 myynti: {data['q3']} euroa
- Q4 myynti: {data['q4']} euroa

Kirjoita 3-4 kappaletta. Analysoi kvartaalien kehitys, nosta esiin paras tuote ja asiakas, 
ja päätä raportti lyhyeen tulevaisuuden näkymään."""

    viesti = client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=1000,
        messages=[{"role": "user", "content": prompt}]
    )

    return viesti.content[0].text

if __name__ == "__main__":
    # Testataan suoraan kovakoodatulla datalla
    testidata = {
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
    
    print("Generoidaan narratiivi Claude API:lla...\n")
    narratiivi = generoi_narratiivi(testidata)
    print(narratiivi)