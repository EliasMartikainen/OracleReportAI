import oracledb
import json
from dotenv import load_dotenv
import os

load_dotenv()

def get_vuosiraportti(vuosi: int) -> dict:
    conn = oracledb.connect(
        user=os.getenv("ORACLE_USER"),
        password=os.getenv("ORACLE_PASSWORD"),
        dsn=os.getenv("ORACLE_DSN")
    )
    
    cursor = conn.cursor()
    kooste = cursor.var(oracledb.DB_TYPE_CLOB)
    
    cursor.callproc("report_pkg.get_vuosiraportti", [vuosi, kooste])
    
    tulos = json.loads(kooste.getvalue().read())
    
    cursor.close()
    conn.close()
    
    return tulos

if __name__ == "__main__":
    data = get_vuosiraportti(2025)
    print(json.dumps(data, indent=2, ensure_ascii=False))