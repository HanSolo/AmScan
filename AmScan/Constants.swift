//
//  Constants.swift
//  AmScan
//
//  Created by Gerrit Grunwald on 13.05.22.
//

import Foundation

public struct Constants {
    
    public static let EVENTS_URL: String = "https://raw.githubusercontent.com/HanSolo/AmScan/main/AmScan/events.json"
    
    public static let NOTES_PLACEHOLDER_STRING: String = "Notes:"
    
    public enum Country: String {
        case AD
        case AE
        case AF
        case AG
        case AI
        case AL
        case AM
        case AN
        case AO
        case AQ
        case AR
        case AS
        case AT
        case AU
        case AW
        case AX
        case AZ
        case BA
        case BB
        case BD
        case BE
        case BF
        case BG
        case BH
        case BI
        case BJ
        case BL
        case BM
        case BN
        case BO
        case BQ
        case BR
        case BS
        case BT
        case BV
        case BW
        case BY
        case BZ
        case CA
        case CC
        case CD
        case CF
        case CG
        case CH
        case CI
        case CK
        case CL
        case CM
        case CN
        case CO
        case CR
        case CU
        case CV
        case CW
        case CX
        case CY
        case CZ
        case DE
        case DJ
        case DK
        case DM
        case DO
        case DZ
        case EC
        case EE
        case EG
        case EH
        case ER
        case ES
        case ET
        case FI
        case FJ
        case FK
        case FM
        case FO
        case FR
        case GA
        case GB
        case GD
        case GE
        case GF
        case GG
        case GH
        case GI
        case GL
        case GM
        case GN
        case GP
        case GQ
        case GR
        case GS
        case GT
        case GU
        case GW
        case GY
        case GZ
        case HK
        case HM
        case HN
        case HR
        case HT
        case HU
        case ID
        case IE
        case IL
        case IM
        case IN
        case IO
        case IQ
        case IR
        case IS
        case IT
        case JE
        case JM
        case JO
        case JP
        case KE
        case KG
        case KH
        case KI
        case KM
        case KN
        case KP
        case KR
        case KW
        case KY
        case KZ
        case LA
        case LB
        case LC
        case LI
        case LK
        case LR
        case LS
        case LT
        case LU
        case LV
        case LY
        case MA
        case MC
        case MD
        case ME
        case MF
        case MG
        case MH
        case MK
        case ML
        case MM
        case MN
        case MO
        case MP
        case MQ
        case MR
        case MS
        case MT
        case MU
        case MV
        case MW
        case MX
        case MY
        case MZ
        case NA
        case NC
        case NE
        case NF
        case NG
        case NI
        case NL
        case NO
        case NP
        case NR
        case NU
        case NZ
        case OM
        case PA
        case PE
        case PF
        case PG
        case PH
        case PK
        case PL
        case PM
        case PN
        case PR
        case PS
        case PT
        case PW
        case PY
        case QA
        case RE
        case RO
        case RS
        case RU
        case RW
        case SA
        case SB
        case SC
        case SD
        case SE
        case SG
        case SH
        case SI
        case SJ
        case SK
        case SL
        case SM
        case SN
        case SO
        case SR
        case SS
        case ST
        case SV
        case SX
        case SY
        case SZ
        case TC
        case TD
        case TF
        case TG
        case TH
        case TJ
        case TK
        case TL
        case TM
        case TN
        case TO
        case TR
        case TT
        case TV
        case TW
        case TZ
        case UA
        case UG
        case UM
        case US
        case AK
        case UY
        case UZ
        case VA
        case VC
        case VE
        case VG
        case VI
        case VN
        case VU
        case WF
        case WS
        case XK
        case YE
        case YT
        case ZA
        case ZM
        case ZW
        case NN
        
        var name: String {
            switch self {
            case .AD: return "Andorra"
            case .AE: return "United Arab Emirates"
            case .AF: return "Afghanistan"
            case .AG: return "Antigua and Barbuda"
            case .AI: return "Anguilla"
            case .AL: return "Albania"
            case .AM: return "Armenia"
            case .AN: return "Netherlands Antilles"
            case .AO: return "Angola"
            case .AQ: return "Antarctica"
            case .AR: return "Argentina"
            case .AS: return "American Samoa"
            case .AT: return "Austria"
            case .AU: return "Australia"
            case .AW: return "Aruba"
            case .AX: return "\u{00C5}land Islands"
            case .AZ: return "Azerbaijan"
            case .BA: return "Bosnia and Herzegovina"
            case .BB: return "Barbados"
            case .BD: return "Bangladesh"
            case .BE: return "Belgium"
            case .BF: return "Burkina Faso"
            case .BG: return "Bulgaria"
            case .BH: return "Bahrain"
            case .BI: return "Burundi"
            case .BJ: return "Benin"
            case .BL: return "Saint Barth\u{00E9}lemy"
            case .BM: return "Bermuda"
            case .BN: return "Brunei"
            case .BO: return "Bolivia"
            case .BQ: return "Bonaire"
            case .BR: return "Brazil"
            case .BS: return "Bahamas"
            case .BT: return "Bhutan"
            case .BV: return "Bouvet Island"
            case .BW: return "Botswana"
            case .BY: return "Belarus"
            case .BZ: return "Belize"
            case .CA: return "Canada"
            case .CC: return "Cocos [Keeling] Islands"
            case .CD: return "Congo [DRC]"
            case .CF: return "Central African Republic"
            case .CG: return "Congo [Republic]"
            case .CH: return "Switzerland"
            case .CI: return "C\u{00F4}te d'Ivoire"
            case .CK: return "Cook Islands"
            case .CL: return "Chile"
            case .CM: return "Cameroon"
            case .CN: return "China"
            case .CO: return "Colombia"
            case .CR: return "Costa Rica"
            case .CU: return "Cuba"
            case .CV: return "Cape Verde"
            case .CW: return "Cura\u{00E7}ao"
            case .CX: return "Christmas Island"
            case .CY: return "Cyprus"
            case .CZ: return "Czech Republic"
            case .DE: return "Germany"
            case .DJ: return "Djibouti"
            case .DK: return "Denmark"
            case .DM: return "Dominica"
            case .DO: return "Dominican Republic"
            case .DZ: return "Algeria"
            case .EC: return "Ecuador"
            case .EE: return "Estonia"
            case .EG: return "Egypt"
            case .EH: return "Western Sahara"
            case .ER: return "Eritrea"
            case .ES: return "Spain"
            case .ET: return "Ethiopia"
            case .FI: return "Finland"
            case .FJ: return "Fiji"
            case .FK: return "Falkland Islands [Islas Malvinas]"
            case .FM: return "Micronesia"
            case .FO: return "Faroe Islands"
            case .FR: return "France"
            case .GA: return "Gabon"
            case .GB: return "United Kingdom"
            case .GD: return "Grenada"
            case .GE: return "Georgia"
            case .GF: return "French Guiana"
            case .GG: return "Guernsey"
            case .GH: return "Ghana"
            case .GI: return "Gibraltar"
            case .GL: return "Greenland"
            case .GM: return "Gambia"
            case .GN: return "Guinea"
            case .GP: return "Guadeloupe"
            case .GQ: return "Equatorial Guinea"
            case .GR: return "Greece"
            case .GS: return "South Georgia and the South Sandwich Islands"
            case .GT: return "Guatemala"
            case .GU: return "Guam"
            case .GW: return "Guinea-Bissau"
            case .GY: return "Guyana"
            case .GZ: return "Gaza Strip"
            case .HK: return "Hong Kong"
            case .HM: return "Heard Island and McDonald Islands"
            case .HN: return "Honduras"
            case .HR: return "Croatia"
            case .HT: return "Haiti"
            case .HU: return "Hungary"
            case .ID: return "Indonesia"
            case .IE: return "Ireland"
            case .IL: return "Israel"
            case .IM: return "Isle of Man"
            case .IN: return "India"
            case .IO: return "British Indian Ocean Territory"
            case .IQ: return "Iraq"
            case .IR: return "Iran"
            case .IS: return "Iceland"
            case .IT: return "Italy"
            case .JE: return "Jersey"
            case .JM: return "Jamaica"
            case .JO: return "Jordan"
            case .JP: return "Japan"
            case .KE: return "Kenya"
            case .KG: return "Kyrgyzstan"
            case .KH: return "Cambodia"
            case .KI: return "Kiribati"
            case .KM: return "Comoros"
            case .KN: return "Saint Kitts and Nevis"
            case .KP: return "North Korea"
            case .KR: return "South Korea"
            case .KW: return "Kuwait"
            case .KY: return "Cayman Islands"
            case .KZ: return "Kazakhstan"
            case .LA: return "Laos"
            case .LB: return "Lebanon"
            case .LC: return "Saint Lucia"
            case .LI: return "Liechtenstein"
            case .LK: return "Sri Lanka"
            case .LR: return "Liberia"
            case .LS: return "Lesotho"
            case .LT: return "Lithuania"
            case .LU: return "Luxembourg"
            case .LV: return "Latvia"
            case .LY: return "Libya"
            case .MA: return "Morocco"
            case .MC: return "Monaco"
            case .MD: return "Moldova"
            case .ME: return "Montenegro"
            case .MF: return "Saint Martin"
            case .MG: return "Madagascar"
            case .MH: return "Marshall Islands"
            case .MK: return "Macedonia [FYROM]"
            case .ML: return "Mali"
            case .MM: return "Myanmar [Burma]"
            case .MN: return "Mongolia"
            case .MO: return "Macau"
            case .MP: return "Northern Mariana Islands"
            case .MQ: return "Martinique"
            case .MR: return "Mauritania"
            case .MS: return "Montserrat"
            case .MT: return "Malta"
            case .MU: return "Mauritius"
            case .MV: return "Maldives"
            case .MW: return "Malawi"
            case .MX: return "Mexico"
            case .MY: return "Malaysia"
            case .MZ: return "Mozambique"
            case .NA: return "Namibia"
            case .NC: return "New Caledonia"
            case .NE: return "Niger"
            case .NF: return "Norfolk Island"
            case .NG: return "Nigeria"
            case .NI: return "Nicaragua"
            case .NL: return "Netherlands"
            case .NO: return "Norway"
            case .NP: return "Nepal"
            case .NR: return "Nauru"
            case .NU: return "Niue"
            case .NZ: return "New Zealand"
            case .OM: return "Oman"
            case .PA: return "Panama"
            case .PE: return "Peru"
            case .PF: return "French Polynesia"
            case .PG: return "Papua New Guinea"
            case .PH: return "Philippines"
            case .PK: return "Pakistan"
            case .PL: return "Poland"
            case .PM: return "Saint Pierre and Miquelon"
            case .PN: return "Pitcairn Islands"
            case .PR: return "Puerto Rico"
            case .PS: return "Palestinian Territories"
            case .PT: return "Portugal"
            case .PW: return "Palau"
            case .PY: return "Paraguay"
            case .QA: return "Qatar"
            case .RE: return "R\u{00E9}union"
            case .RO: return "Romania"
            case .RS: return "Serbia"
            case .RU: return "Russia"
            case .RW: return "Rwanda"
            case .SA: return "Saudi Arabia"
            case .SB: return "Solomon Islands"
            case .SC: return "Seychelles"
            case .SD: return "Sudan"
            case .SE: return "Sweden"
            case .SG: return "Singapore"
            case .SH: return "Saint Helena"
            case .SI: return "Slovenia"
            case .SJ: return "Svalbard and Jan Mayen"
            case .SK: return "Slovakia"
            case .SL: return "Sierra Leone"
            case .SM: return "San Marino"
            case .SN: return "Senegal"
            case .SO: return "Somalia"
            case .SR: return "Suriname"
            case .SS: return "South Sudan"
            case .ST: return "S\u{00E3}o Tom\u{00E9} and Pr\u{00ED}ncipe"
            case .SV: return "El Salvador"
            case .SX: return "Sint Maarten :Dutch part)"
            case .SY: return "Syria"
            case .SZ: return "Swaziland"
            case .TC: return "Turks and Caicos Islands"
            case .TD: return "Chad"
            case .TF: return "French Southern Territories"
            case .TG: return "Togo"
            case .TH: return "Thailand"
            case .TJ: return "Tajikistan"
            case .TK: return "Tokelau"
            case .TL: return "Timor-Leste"
            case .TM: return "Turkmenistan"
            case .TN: return "Tunisia"
            case .TO: return "Tonga"
            case .TR: return "Turkey"
            case .TT: return "Trinidad and Tobago"
            case .TV: return "Tuvalu"
            case .TW: return "Taiwan"
            case .TZ: return "Tanzania"
            case .UA: return "Ukraine"
            case .UG: return "Uganda"
            case .UM: return "U.S. Minor Outlying Islands"
            case .US: return "United States"
            case .AK: return "United States Alaska"
            case .UY: return "Uruguay"
            case .UZ: return "Uzbekistan"
            case .VA: return "Vatican City"
            case .VC: return "Saint Vincent and the Grenadines"
            case .VE: return "Venezuela"
            case .VG: return "British Virgin Islands"
            case .VI: return "U.S. Virgin Islands"
            case .VN: return "Vietnam"
            case .VU: return "Vanuatu"
            case .WF: return "Wallis and Futuna"
            case .WS: return "Samoa"
            case .XK: return "Kosovo"
            case .YE: return "Yemen"
            case .YT: return "Mayotte"
            case .ZA: return "South Africa"
            case .ZM: return "Zambia"
            case .ZW: return "Zimbabwe"
            case .NN: return "Unknown"
            }
        }
        
        public static func fromText(isoCode: String) -> Country {
            return Country(rawValue: isoCode) ?? Country.NN
        }
    }
}
