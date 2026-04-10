-- ============================================
-- OracleReportAI - Myyntidata Schema
-- Jankon Betoni Oy - "Laadukasta betonia 1987 lähtien"
-- ============================================

CREATE TABLE asiakkaat (
    asiakas_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nimi         VARCHAR2(100) NOT NULL,
    kaupunki     VARCHAR2(50),
    segmentti    VARCHAR2(20)
);

CREATE TABLE tuotteet (
    tuote_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nimi         VARCHAR2(100) NOT NULL,
    kategoria    VARCHAR2(50),
    yksikkohinta NUMBER(10,2) NOT NULL
);

CREATE TABLE myynnit (
    myynti_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    asiakas_id   NUMBER REFERENCES asiakkaat(asiakas_id),
    tuote_id     NUMBER REFERENCES tuotteet(tuote_id),
    myyntipaiva  DATE NOT NULL,
    maara        NUMBER NOT NULL,
    yksikkohinta NUMBER(10,2) NOT NULL
);

-- ============================================
-- Testidata
-- ============================================

-- Asiakkaat
INSERT INTO asiakkaat (nimi, kaupunki, segmentti) VALUES ('Heikki Välimäki Ky', 'Tampere', 'yritys');
INSERT INTO asiakkaat (nimi, kaupunki, segmentti) VALUES ('Pentti Kukkonen', 'Hämeenlinna', 'kuluttaja');
INSERT INTO asiakkaat (nimi, kaupunki, segmentti) VALUES ('Möttösen Rakennus Oy', 'Jyväskylä', 'yritys');
INSERT INTO asiakkaat (nimi, kaupunki, segmentti) VALUES ('Reijo Paasonen', 'Tampere', 'kuluttaja');
INSERT INTO asiakkaat (nimi, kaupunki, segmentti) VALUES ('Hirmuinen Oy', 'Helsinki', 'yritys');

-- Tuotteet
INSERT INTO tuotteet (nimi, kategoria, yksikkohinta) VALUES ('Jankon Erikoisbetoni K30', 'Betoni', 320.00);
INSERT INTO tuotteet (nimi, kategoria, yksikkohinta) VALUES ('Peruspilkkabetoni K20', 'Betoni', 180.00);
INSERT INTO tuotteet (nimi, kategoria, yksikkohinta) VALUES ('Betonipumppaus Premium', 'Palvelut', 1200.00);
INSERT INTO tuotteet (nimi, kategoria, yksikkohinta) VALUES ('Jankon Salainen Lisäaine', 'Lisäaineet', 450.00);
INSERT INTO tuotteet (nimi, kategoria, yksikkohinta) VALUES ('Hätäbetoni (24h toimitus)', 'Betoni', 580.00);

-- Myynnit Q1-Q4 2025
-- Q1
INSERT INTO myynnit VALUES (DEFAULT, 1, 1, DATE '2025-01-15', 10, 320.00);
INSERT INTO myynnit VALUES (DEFAULT, 2, 2, DATE '2025-02-10', 5, 180.00);
INSERT INTO myynnit VALUES (DEFAULT, 3, 3, DATE '2025-03-05', 2, 1200.00);
INSERT INTO myynnit VALUES (DEFAULT, 4, 4, DATE '2025-03-20', 3, 450.00);
-- Q2
INSERT INTO myynnit VALUES (DEFAULT, 1, 3, DATE '2025-04-08', 1, 1200.00);
INSERT INTO myynnit VALUES (DEFAULT, 2, 5, DATE '2025-05-15', 4, 580.00);
INSERT INTO myynnit VALUES (DEFAULT, 5, 1, DATE '2025-06-01', 20, 320.00);
INSERT INTO myynnit VALUES (DEFAULT, 4, 2, DATE '2025-06-20', 8, 180.00);
-- Q3
INSERT INTO myynnit VALUES (DEFAULT, 1, 4, DATE '2025-07-10', 6, 450.00);
INSERT INTO myynnit VALUES (DEFAULT, 3, 1, DATE '2025-08-05', 15, 320.00);
INSERT INTO myynnit VALUES (DEFAULT, 2, 3, DATE '2025-09-12', 3, 1200.00);
INSERT INTO myynnit VALUES (DEFAULT, 5, 5, DATE '2025-09-28', 2, 580.00);
-- Q4
INSERT INTO myynnit VALUES (DEFAULT, 4, 5, DATE '2025-10-15', 5, 580.00);
INSERT INTO myynnit VALUES (DEFAULT, 1, 1, DATE '2025-11-08', 12, 320.00);
INSERT INTO myynnit VALUES (DEFAULT, 3, 4, DATE '2025-12-01', 4, 450.00);
INSERT INTO myynnit VALUES (DEFAULT, 2, 2, DATE '2025-12-20', 7, 180.00);

COMMIT;