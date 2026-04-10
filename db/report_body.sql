CREATE OR REPLACE PACKAGE BODY report_pkg AS

    PROCEDURE get_vuosiraportti(
        p_vuosi IN NUMBER,
        p_kooste OUT CLOB
    ) AS
        v_kokonaismyynti    NUMBER;
        v_myyntikpl         NUMBER;
        v_paras_tuote       VARCHAR2(100);
        v_paras_asiakas     VARCHAR2(100);
        v_q1                NUMBER;
        v_q2                NUMBER;
        v_q3                NUMBER;
        v_q4                NUMBER;
    BEGIN
        SELECT SUM(maara * yksikkohinta), COUNT(*)
        INTO v_kokonaismyynti, v_myyntikpl
        FROM myynnit
        WHERE EXTRACT(YEAR FROM myyntipaiva) = p_vuosi;

        SELECT nimi INTO v_paras_tuote
        FROM (
            SELECT t.nimi, SUM(m.maara * m.yksikkohinta) AS myynti
            FROM myynnit m
            JOIN tuotteet t ON t.tuote_id = m.tuote_id
            WHERE EXTRACT(YEAR FROM m.myyntipaiva) = p_vuosi
            GROUP BY t.nimi
            ORDER BY myynti DESC
        ) WHERE ROWNUM = 1;

        SELECT nimi INTO v_paras_asiakas
        FROM (
            SELECT a.nimi, SUM(m.maara * m.yksikkohinta) AS myynti
            FROM myynnit m
            JOIN asiakkaat a ON a.asiakas_id = m.asiakas_id
            WHERE EXTRACT(YEAR FROM m.myyntipaiva) = p_vuosi
            GROUP BY a.nimi
            ORDER BY myynti DESC
        ) WHERE ROWNUM = 1;

        SELECT
            NVL(SUM(CASE WHEN EXTRACT(MONTH FROM myyntipaiva) BETWEEN 1 AND 3
                    THEN maara * yksikkohinta END), 0),
            NVL(SUM(CASE WHEN EXTRACT(MONTH FROM myyntipaiva) BETWEEN 4 AND 6
                    THEN maara * yksikkohinta END), 0),
            NVL(SUM(CASE WHEN EXTRACT(MONTH FROM myyntipaiva) BETWEEN 7 AND 9
                    THEN maara * yksikkohinta END), 0),
            NVL(SUM(CASE WHEN EXTRACT(MONTH FROM myyntipaiva) BETWEEN 10 AND 12
                    THEN maara * yksikkohinta END), 0)
        INTO v_q1, v_q2, v_q3, v_q4
        FROM myynnit
        WHERE EXTRACT(YEAR FROM myyntipaiva) = p_vuosi;

        p_kooste :=
            '{"vuosi": '          || p_vuosi          ||
            ', "kokonaismyynti": '|| v_kokonaismyynti ||
            ', "myyntikpl": '     || v_myyntikpl       ||
            ', "paras_tuote": "'  || v_paras_tuote     ||
            '", "paras_asiakas": "'|| v_paras_asiakas  ||
            '", "q1": '           || v_q1              ||
            ', "q2": '            || v_q2              ||
            ', "q3": '            || v_q3              ||
            ', "q4": '            || v_q4              ||
            '}';

    END get_vuosiraportti;

END report_pkg;
/
SHOW ERRORS;
EXIT;