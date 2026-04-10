from flask import Flask, render_template, jsonify
import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from db_connector import get_vuosiraportti
from report_generator import generoi_narratiivi
from datetime import datetime

app = Flask(__name__, template_folder="../templates")

@app.route("/")
def etusivu():
    return render_template("index.html")

@app.route("/generoi/<int:vuosi>")
def generoi(vuosi):
    try:
        data = get_vuosiraportti(vuosi)
        narratiivi = generoi_narratiivi(data)
        return jsonify({
            "ok": True,
            "data": data,
            "narratiivi": narratiivi,
            "paivamaara": datetime.now().strftime("%d.%m.%Y")
        })
    except Exception as e:
        return jsonify({"ok": False, "virhe": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True, port=5000)