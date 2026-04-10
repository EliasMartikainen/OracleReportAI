from db_connector import get_vuosiraportti
from report_generator import generoi_narratiivi
from jinja2 import Environment, FileSystemLoader
import os
from datetime import datetime

def luo_raportti(vuosi: int):
    print(f"Haetaan data Oraclesta vuodelle {vuosi}...")
    data = get_vuosiraportti(vuosi)

    print("Generoidaan narratiivi Claude API:lla...")
    narratiivi = generoi_narratiivi(data)

    print("Luodaan HTML-raportti...")
    env = Environment(loader=FileSystemLoader("templates"))
    template = env.get_template("report.html")

    html = template.render(
        data=data,
        narratiivi=narratiivi,
        paivamaara=datetime.now().strftime("%d.%m.%Y")
    )

    os.makedirs("output", exist_ok=True)
    tiedosto = f"output/raportti_{vuosi}.html"
    with open(tiedosto, "w", encoding="utf-8") as f:
        f.write(html)

    print(f"Raportti valmis: {tiedosto}")

if __name__ == "__main__":
    luo_raportti(2025)