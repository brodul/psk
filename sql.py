# -*- coding:utf-8 -*-

"""A very well time consuming project for university."""
import datetime

from sqlalchemy import (
    create_engine,
    Column, DateTime,
    Integer, Unicode, ForeignKey, Table)
from sqlalchemy.sql.expression import func
from sqlalchemy.orm import relationship, sessionmaker, scoped_session
from sqlalchemy.ext.declarative import declarative_base, declared_attr


engine = create_engine('postgresql://kso:kso@localhost:5433/kso', echo=True)
Session = scoped_session(sessionmaker(autocommit=False,
                                      autoflush=False,
                                      bind=engine))


class BaseMixin(object):
    query = Session.query_property()

    @declared_attr
    def __tablename__(cls):
        """Use tablename as lowercase class name"""
        return cls.__name__.lower()

    def __init__(self, **kwargs):
        for k, v in kwargs.iteritems():
            setattr(self, k, v)

    def __repr__(self):
        attrs = ', '.join([key + "=" + str(value)
                           for key, value
                           in self.__dict__.iteritems()
                           if not key.startswith('_')])
        return "<%s %s>" % (self.__class__.__name__,
                            attrs)

Base = declarative_base(bind=engine, cls=BaseMixin)


class Stranka(Base):
    __tablename__ = 'stranka'

    id = Column(Integer, primary_key=True)
    ime = Column(Unicode, nullable=False)
    priimek = Column(Unicode, nullable=False)

    narocilo = relationship('Narocilo')


class Narocilo(Base):
    __tablename__ = 'narocilo'

    id = Column(Integer, primary_key=True)
    stranka = Column(Integer, ForeignKey('stranka.id'), nullable=False)
    poslovalnica = Column(Integer, ForeignKey('poslovalnica.id'), nullable=False)
    datum = Column(DateTime, nullable=False)

    enoloncnica = relationship("Enoloncnica",
                               secondary="narocilo_enoloncnica",
                               backref="narocilo")


narocilo_enoloncnica = Table(
    'narocilo_enoloncnica',
    Base.metadata,
    Column('narocilo', Integer, ForeignKey('narocilo.id'), nullable=False),
    Column('enoloncnica', Integer, ForeignKey('enoloncnica.id'), nullable=False),
)

enoloncnica_poslovalnica = Table(
    'enoloncnica_poslovalnica',
    Base.metadata,
    Column('poslovalnica', Integer, ForeignKey('poslovalnica.id'), nullable=False),
    Column('enoloncnica', Integer, ForeignKey('enoloncnica.id'), nullable=False),
)

sestavina_enoloncnica = Table(
    'sestavina_enoloncnica',
    Base.metadata,
    Column('sestavina', Integer, ForeignKey('sestavina.id'), nullable=False),
    Column('enoloncnica', Integer, ForeignKey('enoloncnica.id'), nullable=False),
)


class Poslovalnica(Base):
    __tablename__ = 'poslovalnica'

    id = Column(Integer, primary_key=True)
    ime = Column(Unicode, nullable=False)
    ulica = Column(Unicode, nullable=False)
    hisna_stevilka = Column(Unicode, nullable=False)
    postna_stevilka = Column(Unicode, nullable=False)

    narocilo = relationship('Narocilo')
    enoloncnica = relationship("Enoloncnica",
                               secondary="enoloncnica_poslovalnica",
                               backref="poslovalnica")


class Enoloncnica(Base):
    __tablename__ = 'enoloncnica'

    id = Column(Integer, primary_key=True)
    ime = Column(Unicode, nullable=False)
    cena = Column(Integer, nullable=False)

    sestavina = relationship("Sestavina",
                             secondary="sestavina_enoloncnica",
                             backref="enoloncnica")


class Sestavina(Base):
    __tablename__ = 'sestavina'

    id = Column(Integer, primary_key=True)
    ime = Column(Unicode, nullable=False)
    dobavitelj = Column(Integer, ForeignKey('dobavitelj.id'), nullable=False)


class Dobavitelj(Base):
    __tablename__ = 'dobavitelj'

    id = Column(Integer, primary_key=True)
    ime = Column(Unicode, nullable=False)
    sestavina = relationship('Sestavina')


def main():
    Base.metadata.drop_all()
    Base.metadata.create_all()

    # populate data
    Session.add_all([
        Dobavitelj(ime='Kolinska'),
        Dobavitelj(ime='Mercator'),
        Dobavitelj(ime='Tus'),
    ])

    s1 = Sestavina(ime='krompir', dobavitelj=1)
    s2 = Sestavina(ime='fizol', dobavitelj=2)
    s3 = Sestavina(ime='zelje', dobavitelj=3)
    s4 = Sestavina(ime='jespren', dobavitelj=2)
    s5 = Sestavina(ime='korenje', dobavitelj=3)
    s6 = Sestavina(ime='piscanec', dobavitelj=1)
    Session.add_all([s1, s2, s3, s4, s5, s6])

    p1 = Poslovalnica(ime='Ziga Zaga d.o.o.',
                      ulica='Kersnikova',
                      hisna_stevilka=6,
                      postna_stevilka=1000)
    p2 = Poslovalnica(ime='Volta Morta s.p.',
                      ulica='Dunajska',
                      hisna_stevilka=86,
                      postna_stevilka=1000)
    p3 = Poslovalnica(ime='Butl tesla s.p.',
                      ulica='Slovenska',
                      hisna_stevilka=200,
                      postna_stevilka=1000)
    Session.add_all([p1, p2, p3])

    st1 = Stranka(ime='Joze', priimek='Zbogar')
    st2 = Stranka(ime='Mirko', priimek='Semu')
    st3 = Stranka(ime='Tina', priimek='Zore')
    st4 = Stranka(ime='Gorazd', priimek='Boromir')
    Session.add_all([st1, st2, st3, st4])

    e1 = Enoloncnica(ime='jota', cena=10, sestavina=[s2, s4],
                     poslovalnica=[p1, p2])
    e2 = Enoloncnica(ime='pasulj', cena=6, sestavina=[s2, s5],
                     poslovalnica=[p1])
    e3 = Enoloncnica(ime='ricet', cena=6, sestavina=[s5, s1, s3])
    e4 = Enoloncnica(ime='piscancja obara', cena=11, sestavina=[s6])
    Session.add_all([e1, e2, e3, e4])

    Session.flush()
    Session.add_all([
        Narocilo(stranka=st1.id,
                 enoloncnica=[e1, e2],
                 poslovalnica=p1.id,
                 datum=datetime.datetime(2013, 2, 1)),
        Narocilo(stranka=st2.id,
                 enoloncnica=[e2],
                 poslovalnica=p2.id,
                 datum=datetime.datetime(2013, 1, 1)),
        Narocilo(stranka=st3.id,
                 enoloncnica=[e1, e2, e1],
                 poslovalnica=p2.id,
                 datum=datetime.datetime(2013, 2, 5)),
    ])

    Session.commit()

    print
    print('Vse enoloncnice, ki imajo enako ceno kot jota enoloncnica:')
    print
    subquery = Enoloncnica.query.with_entities(Enoloncnica.cena)\
                          .filter(Enoloncnica.ime == 'pasulj').subquery()
    r = Enoloncnica.query.filter(Enoloncnica.cena.in_(subquery)).all()
    print(r)

    print
    print('Vse enoloncnice, ki jih v zadnjem tednu ni nihce narocil')
    print
    q = Enoloncnica.query
    q = q.outerjoin(Narocilo, Enoloncnica.narocilo)
    r = q.filter(~Enoloncnica.narocilo.any(Narocilo.datum > datetime.datetime(2013, 2, 1))).all()
    print r

    print
    print('Vse enoloncnice, ki so se v zadnjih 10 dneh prodale v Ziga Zaga d.o.o.')
    print
    q = Enoloncnica.query
    q = q.join(Narocilo, Enoloncnica.narocilo)
    q = q.join(Poslovalnica)
    q = q.filter(Narocilo.datum > datetime.datetime(2013, 1, 29))
    r = q.filter(Poslovalnica.ime == "Ziga Zaga d.o.o.").all()
    print r

    print
    print('Vse enoloncnice katerih Joze Zbogar v zadnjih 10 dneh ni kupil nobene')
    print
    r = engine.execute("""
     SELECT id, ime FROM enoloncnica
                    WHERE NOT id IN (
                        SELECT enoloncnica FROM narocilo_enoloncnica AS na, narocilo AS n
                                           WHERE na.narocilo = n.id
                                                 AND n.stranka IN (SELECT id FROM stranka WHERE ime='Joze' AND priimek='Zbogar'))
    """).fetchall()
    print r

    print
    print('Vse enoloncnice in za vsako stevilo prodanih v zadnjem mesecu')
    print
    q = Enoloncnica.query.with_entities(Enoloncnica, func.count(Enoloncnica.id))
    q = q.join(Narocilo, Enoloncnica.narocilo)
    q = q.group_by(Enoloncnica)
    r = q.filter(Narocilo.datum > datetime.datetime(2013, 1, 8)).all()
    print r

    print
    print('Katere stranke v zadnjem mesecu niso naredile narocil')
    print
    q = Stranka.query
    q = q.outerjoin(Narocilo, Enoloncnica.narocilo)
    r = q.filter(~Stranka.narocilo.any(Narocilo.datum > datetime.datetime(2013, 1, 8))).all()
    print r

    print
    print('Vse stranke, ki so v zadnjem mesecu narocile za vec kot 10 eur enoloncnic')
    print
    r = engine.execute("""
        SELECT s.ime, sum(e.cena) FROM stranka AS s, narocilo AS n, narocilo_enoloncnica AS na, enoloncnica AS e
                                 WHERE s.id = n.stranka AND n.id = na.narocilo AND na.enoloncnica = e.id AND
                                       n.datum > '2013-01-08 00:00:00.000000'
                                 GROUP BY s.id
                                 HAVING sum(e.cena) > 4
    """).fetchall()
    print r

    # TODO: V porocilo napisite na svoj problem prevedena vprasanja in pri vsakem SQL kodo.


if __name__ == '__main__':
    main()
