#!/bin/bash

# mkae n2tfile for building GO

# graphene 001 CGRA ;
# carboxy  002 CCAR1 ; 003 CCAR ; 004 OCAR1 ; 005 OCAR2 ; 006 HCAR ;
# hydroxy  007 CHYD ; 008 OHYD ; 009 HHYD ;
# epoxy    010 CEPO ; 011 OEPO ;
echo '; graphene ' > GO.n2t

mcarbon=12.011   moxygen=15.9994   mhydrogen=1.008
#graphene
bondccgra=0.3 #0.142
qCGRA=0
atomtype="CGRA   opls_001   $qCGRA   $mcarbon  3   CGRA  $bondccgra  CGRA $bondccgra  CGRA $bondccgra"
echo $atomtype >> GO.n2t
atomtype="CGRA   opls_001   $qCGRA   $mcarbon  2   CGRA  $bondccgra  CGRA $bondccgra"
echo $atomtype >> GO.n2t
atomtype="CGRA   opls_001   $qCGRA   $mcarbon  1   CGRA  $bondccgra"
echo $atomtype >> GO.n2t


echo '' >> GO.n2t
echo '; carboxy C1 C O1(double) O2 H ' >> GO.n2t
#carboxy C1 C O1(double) O2 H
bondcccar=0.156 #0.156
bondcocar1=0.119 #0.119
bondcocar2=0.134 #0.134
bondohcar=0.097

qCCAR1=0.08    qCCAR=0.55     qOCAR1=-0.50     qOCAR2=-0.58     qHCAR=0.45

#CCAR1
atomtype="CGRA   opls_002   $qCCAR1   $mcarbon  4   CGRA  $bondccgra  CGRA $bondccgra  CGRA $bondccgra CCAR $bondcccar"
echo $atomtype >> GO.n2t
atomtype="CGRA   opls_002   $qCCAR1   $mcarbon  3   CGRA  $bondccgra  CGRA $bondccgra  CCAR $bondcccar"
echo $atomtype >> GO.n2t
atomtype="CGRA   opls_002   $qCCAR1   $mcarbon  2   CGRA  $bondccgra  CCAR $bondcccar"
echo $atomtype >> GO.n2t

#CCAR
atomtype="CCAR   opls_003   $qCCAR   $mcarbon   3  CGRA $bondcccar  OCAR1 $bondcocar1 OCAR2 $bondcocar2"
echo $atomtype >> GO.n2t
#OCAR1
atomtype="OCAR1  opls_004   $qOCAR1  $moxygen   1  CCAR $bondcocar1"
echo $atomtype >> GO.n2t
#OCAR2
atomtype="OCAR2  opls_005   $qOCAR2  $moxygen   2  CCAR $bondcocar2 HCAR $bondohcar"
echo $atomtype >> GO.n2t
#HCAR
atomtype="HCAR   opls_006   $qHCAR   $mhydrogen   1   OCAR2  $bondohcar "
echo $atomtype >> GO.n2t

echo '' >> GO.n2t
echo '; hydroxy ' >> GO.n2t
#hydroxy
bondcohyd=0.146 #0.146
bondohhyd=0.097
qCHYD=0.1966  qOHYD=-0.5260   qHHYD=0.3294
#CHYD
atomtype="CGRA   opls_007   $qCHYD  $mcarbon  4   CGRA  $bondccgra  CGRA $bondccgra  CGRA $bondccgra OHYD $bondcohyd"
echo $atomtype >> GO.n2t
atomtype="CGRA   opls_007   $qCHYD   $mcarbon  3   CGRA  $bondccgra  CGRA $bondccgra OHYD $bondcohyd"
echo $atomtype >> GO.n2t
atomtype="CGRA   opls_007   $qCHYD   $mcarbon  2   CGRA  $bondccgra  OHYD $bondcohyd"
echo $atomtype >> GO.n2t
#OHYD
atomtype="OHYD   opls_008   $qOHYD   $moxygen  2   CGRA  $bondcohyd  HHYD $bondohhyd"
echo $atomtype >> GO.n2t
#HHYD
atomtype="HHYD   opls_009   $qHHYD   $mhydrogen  1  OHYD $bondohhyd"
echo $atomtype >> GO.n2t

echo '' >> GO.n2t
echo '; epoxy ' >> GO.n2t
#epoxy
bondcoepo=0.192   #0.139
qCEPO=0.2  qOEPO=-0.4
#CEPO
atomtype="CGRA   opls_010   $qCEPO   $mcarbon  4   CGRA  $bondccgra  CGRA $bondccgra  CGRA $bondccgra OEPO $bondcoepo"
echo $atomtype >> GO.n2t
atomtype="CGRA   opls_010   $qCEPO   $mcarbon  3   CGRA $bondccgra   CGRA $bondccgra OEPO $bondcoepo"
echo $atomtype >> GO.n2t
atomtype="CGRA   opls_010   $qCEPO   $mcarbon  2   CGRA $bondccgra  OEPO $bondcoepo"
#OPO
atomtype="OEPO   opls_011   $qOEPO   $moxygen  2   CGRA  $bondcoepo  CGRA $bondcoepo"
echo $atomtype >> GO.n2t

mv GO.n2t ./oplsaaGO.ff/GO.n2t
