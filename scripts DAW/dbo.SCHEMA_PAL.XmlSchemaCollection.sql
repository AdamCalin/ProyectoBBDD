USE [DAW]
GO
/****** Object:  XmlSchemaCollection [dbo].[SCHEMA_PAL]    Script Date: 27/05/2022 15:00:56 ******/
CREATE XML SCHEMA COLLECTION [dbo].[SCHEMA_PAL] AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified"><xsd:element name="r"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="i" type="xsd:string" minOccurs="0" maxOccurs="unbounded" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:schema>'
GO
