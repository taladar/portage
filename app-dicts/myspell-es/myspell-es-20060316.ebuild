# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-es/myspell-es-20060316.ebuild,v 1.16 2010/05/13 19:29:36 josejx Exp $

MYSPELL_SPELLING_DICTIONARIES=(
"es,AR,es_AR,Spanish (Argentina),es_AR.zip"
"es,BZ,es_HN,Spanish (Belize),es_HN.zip"
"es,BO,es_BO,Spanish (Bolivia),es_BO.zip"
"es,CL,es_CL,Spanish (Chile),es_CL.zip"
"es,CO,es_CO,Spanish (Colombia),es_CO.zip"
"es,CR,es_CR,Spanish (Costa Rica),es_CR.zip"
"es,CU,es_CU,Spanish (Cuba),es_CU.zip"
"es,DO,es_DO,Spanish (Dominican Republic),es_DO.zip"
"es,EC,es_EC,Spanish (Ecuador),es_EC.zip"
"es,SV,es_SV,Spanish (El Salvador),es_SV.zip"
"es,GT,es_GT,Spanish (Guatemala),es_GT.zip"
"es,HN,es_HN,Spanish (Honduras),es_HN.zip"
"es,MX,es_MX,Spanish (Mexico),es_MX.zip"
"es,NI,es_NI,Spanish (Nicaragua),es_NI.zip"
"es,PA,es_PA,Spanish (Panama),es_PA.zip"
"es,PY,es_PY,Spanish (Paraguay),es_PY.zip"
"es,PE,es_PE,Spanish (Peru),es_PE.zip"
"es,PR,es_PR,Spanish (Puerto Rico),es_PR.zip"
"es,ES,es_ES,Spanish (Spain),es_ES.zip"
"es,UY,es_UY,Spanish (Uruguay),es_UY.zip"
"es,VE,es_VE,Spanish (Venezuela),es_VE.zip"
"gl,ES,gl_ES,Galician (Spain),gl_ES.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"es,AR,hyph_es_ES,Spanish (Argentina),hyph_es_ES.zip"
"es,BZ,hyph_es_ES,Spanish (Belize),hyph_es_ES.zip"
"es,BO,hyph_es_ES,Spanish (Bolivia),hyph_es_ES.zip"
"es,CL,hyph_es_ES,Spanish (Chile),hyph_es_ES.zip"
"es,CO,hyph_es_ES,Spanish (Colombia),hyph_es_ES.zip"
"es,CR,hyph_es_ES,Spanish (Costa Rica),hyph_es_ES.zip"
"es,CU,hyph_es_ES,Spanish (Cuba),hyph_es_ES.zip"
"es,DO,hyph_es_ES,Spanish (Dominican Republic),hyph_es_ES.zip"
"es,EC,hyph_es_ES,Spanish (Ecuador),hyph_es_ES.zip"
"es,SV,hyph_es_ES,Spanish (El Salvador),hyph_es_ES.zip"
"es,GT,hyph_es_ES,Spanish (Guatemala),hyph_es_ES.zip"
"es,HN,hyph_es_ES,Spanish (Honduras),hyph_es_ES.zip"
"es,MX,hyph_es_ES,Spanish (Mexico),hyph_es_ES.zip"
"es,NI,hyph_es_ES,Spanish (Nicaragua),hyph_es_ES.zip"
"es,PA,hyph_es_ES,Spanish (Panama),hyph_es_ES.zip"
"es,PY,hyph_es_ES,Spanish (Paraguay),hyph_es_ES.zip"
"es,PE,hyph_es_ES,Spanish (Peru),hyph_es_ES.zip"
"es,PR,hyph_es_ES,Spanish (Puerto Rico),hyph_es_ES.zip"
"es,ES,hyph_es_ES,Spanish (Spain),hyph_es_ES.zip"
"es,UY,hyph_es_ES,Spanish (Uruguay),hyph_es_ES.zip"
"es,VE,hyph_es_ES,Spanish (Venezuela),hyph_es_ES.zip"
"gl,ES,hyph_es_ES,Galician (Spain),hyph_es_ES.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
"es,AR,th_es_ES,Spanish (Argentina),thes_es_ES.zip"
"es,BZ,th_es_ES,Spanish (Belize),thes_es_ES.zip"
"es,BO,th_es_ES,Spanish (Bolivia),thes_es_ES.zip"
"es,CL,th_es_ES,Spanish (Chile),thes_es_ES.zip"
"es,CO,th_es_ES,Spanish (Colombia),thes_es_ES.zip"
"es,CR,th_es_ES,Spanish (Costa Rica),thes_es_ES.zip"
"es,CU,th_es_ES,Spanish (Cuba),thes_es_ES.zip"
"es,DO,th_es_ES,Spanish (Dominican Republic),thes_es_ES.zip"
"es,EC,th_es_ES,Spanish (Ecuador),thes_es_ES.zip"
"es,SV,th_es_ES,Spanish (El Salvador),thes_es_ES.zip"
"es,GT,th_es_ES,Spanish (Guatemala),thes_es_ES.zip"
"es,HN,th_es_ES,Spanish (Honduras),thes_es_ES.zip"
"es,MX,th_es_ES,Spanish (Mexico),thes_es_ES.zip"
"es,NI,th_es_ES,Spanish (Nicaragua),thes_es_ES.zip"
"es,PA,th_es_ES,Spanish (Panama),thes_es_ES.zip"
"es,PY,th_es_ES,Spanish (Paraguay),thes_es_ES.zip"
"es,PE,th_es_ES,Spanish (Peru),thes_es_ES.zip"
"es,PR,th_es_ES,Spanish (Puerto Rico),thes_es_ES.zip"
"es,ES,th_es_ES,Spanish (Spain),thes_es_ES.zip"
"es,UY,th_es_ES,Spanish (Uruguay),thes_es_ES.zip"
"es,VE,th_es_ES,Spanish (Venezuela),thes_es_ES.zip"
)

inherit myspell

DESCRIPTION="Spanish and Galician dictionaries for myspell/hunspell"
LICENSE="GPL-2 LGPL-2.1"
HOMEPAGE="http://lingucomponent.openoffice.org/ http://sourceforge.net/projects/openoffice-es/ http://openoffice-es.sf.net/thesaurus/"
IUSE=""

KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"
