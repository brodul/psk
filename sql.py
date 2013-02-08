# -*- coding:utf-8 -*-

"""A very well time consuming project for university."""

from sqlalchemy import (
    create_engine, Column, Integer, Unicode, ForeignKey, Table)
from sqlalchemy.orm import relationship, sessionmaker, scoped_session
from sqlalchemy.ext.declarative import declarative_base, declared_attr


engine = create_engine('sqlite:///', echo=True)
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
    stranka = Column(Integer, ForeignKey('stranka.id'))
    poslovalnica = Column(Integer, ForeignKey('poslovalnica.id'))

    enoloncnica = relationship("Enoloncnica", secondary="narocilo_enoloncnica")


narocilo_enoloncnica = Table(
    'narocilo_enoloncnica',
    Base.metadata,
    Column('narocilo', Integer, ForeignKey('narocilo.id')),
    Column('enoloncnica', Integer, ForeignKey('enoloncnica.id')),
)

enoloncnica_poslovalnica = Table(
    'enoloncnica_poslovalnica',
    Base.metadata,
    Column('poslovalnica', Integer, ForeignKey('poslovalnica.id')),
    Column('enoloncnica', Integer, ForeignKey('enoloncnica.id')),
)

sestavina_enoloncnica = Table(
    'sestavina_enoloncnica',
    Base.metadata,
    Column('sestavina', Integer, ForeignKey('sestavina.id')),
    Column('enoloncnica', Integer, ForeignKey('enoloncnica.id')),
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
                               secondary="enoloncnica_poslovalnica")


class Enoloncnica(Base):
    __tablename__ = 'enoloncnica'

    id = Column(Integer, primary_key=True)
    ime = Column(Unicode, nullable=False)
    cena = Column(Integer, nullable=False)

    sestavina = relationship("Sestavina", secondary="sestavina_enoloncnica")


class Sestavina(Base):
    __tablename__ = 'sestavina'

    id = Column(Integer, primary_key=True)
    ime = Column(Unicode, nullable=False)
    dobavitelj = Column(Integer, ForeignKey('dobavitelj.id'))


class Dobavitelj(Base):
    __tablename__ = 'dobavitelj'

    id = Column(Integer, primary_key=True)
    ime = Column(Unicode, nullable=False)
    sestavina = relationship('Sestavina')


def main():
    Base.metadata.create_all()

    # populate data
    Session.add_all([
        Dobavitelj(ime='Kolinska'),
        Dobavitelj(ime='Mercator'),
        Dobavitelj(ime='Tus'),
    ])
    Session.add_all([
        Sestavina(ime='krompir', dobavitelj=1),
        Sestavina(ime='fizol', dobavitelj=2),
        Sestavina(ime='zelje', dobavitelj=3),
        Sestavina(ime='jespren', dobavitelj=2),
        Sestavina(ime='korenje', dobavitelj=3),
    ])
    Session.add_all([
        Poslovalnica(ime='Ziga zaga d.o.o.',
                     ulica='Kersnikova',
                     hisna_stevilka=6,
                     postna_stevilka=1000),
        Poslovalnica(ime='Volta Morta s.p.',
                     ulica='Dunajska',
                     hisna_stevilka=86,
                     postna_stevilka=1000),
        Poslovalnica(ime='Butl tesla s.p.',
                     ulica='Slovenska',
                     hisna_stevilka=200,
                     postna_stevilka=1000),
    ])
    Session.add_all([
        Enoloncnica(ime='jota', cena=10),
        Enoloncnica(ime='pasulj', cena=6),
        Enoloncnica(ime='ricet', cena=4),
    ])
    Session.add_all([
        Stranka(ime='Joze', priimek='Zbogar'),
        Stranka(ime='Mirko', priimek='Semu'),
        Stranka(ime='Tina', priimek='Zore'),
    ])
    #Session.add_all([
    #    Narocilo(),
    #])
    Session.commit()

    # TODO: add m2m data, write queries
    import pdb; pdb.set_trace()

    #Vse pice, ki imajo enako ceno kot kraska pica.
    #Vse pice, ki jih v zadnjem tednu ni nihce narocil.
    #Vse pice, ki jih je v zadnjih 10 dneh dostavil dostavljalec Zare Lepotec.
    #Vse pice, katerih (vrste) Zare Lepotec v zadnjih 10 dneh ni dostavil nobene.
    #Vse vrste pic in za vsako stevilo prodanih v zadnjem mesecu.
    #Katere stranke v zadnjem letu niso imele narocil?
    #Vse stranke, ki so v zadnjem mesecu narocile za vec kot 50 eur pic.

    # TODO: V porocilo napisite na svoj problem prevedena vprasanja in pri vsakem SQL kodo.


if __name__ == '__main__':
    main()
