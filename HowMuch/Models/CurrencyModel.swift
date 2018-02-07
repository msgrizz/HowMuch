//
//  CurrenciesModel.swift
//  HowMuch
//
//  Created by Максим Казаков on 08/01/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation


struct Currency: Hashable, RawRepresentable, CustomStringConvertible {
    
    let shortName: String
    let name: String
    let sign: String
    let flag: String
    
    init(shortName: String, name: String, sign: String, flag: String ) {
        self.shortName = shortName
        self.name = name
        self.sign = sign
        self.flag = flag
    }
    
    static let RON = Currency(shortName: "RON", name: "Romanian leu", sign: "lei", flag: "🇷🇴" )
    static let MYR = Currency(shortName: "MYR", name: "Malaysian ringgit", sign: "RM", flag: "🇲🇾" )
    static let XAF = Currency(shortName: "XAF", name: "Central African CFA franc", sign: "₣", flag: "🇨🇫" )
    static let SVC = Currency(shortName: "SVC", name: "El Salvador Colon", sign: "₡", flag: "🇸🇻" )
    static let BTN = Currency(shortName: "BTN", name: "Ngultrum", sign: "Nu", flag: "🇧🇹" )
    static let BWP = Currency(shortName: "BWP", name: "Pula", sign: "P", flag: "🇧🇼" )
    static let NGN = Currency(shortName: "NGN", name: "Naira", sign: "₦", flag: "🇳🇬" )
    static let MRO = Currency(shortName: "MRO", name: "Mauritanian ouguiya", sign: "UM", flag: "🇲🇷" )
    static let MAD = Currency(shortName: "MAD", name: "Moroccan dirham", sign: "DH", flag: "🇲🇦" )
    static let HTG = Currency(shortName: "HTG", name: "Haitian gourde", sign: "G", flag: "🇭🇹" ) // гаити
    static let SGD = Currency(shortName: "SGD", name: "Singapore dollar", sign: "$", flag: "🇸🇬" ) //
    static let ALL = Currency(shortName: "ALL", name: "Albanian lek", sign: "L", flag: "🇦🇱" ) // албиания
    static let RWF = Currency(shortName: "RWF", name: "Rwandan franc", sign: "₣", flag: "🇷🇼" ) //
    static let JEP = Currency(shortName: "JEP", name: "Jersey pound", sign: "£", flag: "🇯🇪" ) //
    static let TZS = Currency(shortName: "TZS", name: "Tanzanian shilling", sign: "TSh", flag: "🇹🇿" ) //
    static let SLL = Currency(shortName: "SLL", name: "Sierra Leonean leone", sign: "TSh", flag: "🇸🇱" ) // Сьерра-Леоне
    static let TWD = Currency(shortName: "TWD", name: "New Taiwan dollar", sign: "NT$", flag: "🇹🇼" ) // Китайская республика
    static let MVR = Currency(shortName: "MVR", name: "Maldivian rufiyaa", sign: "Rf", flag: "🇲🇻" ) // Мальдивы
    static let AMD = Currency(shortName: "AMD", name: "Armenian dram", sign: "?", flag: "🇦🇲" ) //
    static let LAK = Currency(shortName: "LAK", name: "Lao kip", sign: "₭", flag: "🇱🇦" ) // Лаос
    static let GEL = Currency(shortName: "GEL", name: "Georgian lari", sign: "₾", flag: "🇬🇪" ) // Грузия
    static let BND = Currency(shortName: "BND", name: "Brunei dollar", sign: "$", flag: "🇧🇳" ) // Бруней
    static let KGS = Currency(shortName: "KGS", name: "Kyrgyzstani som", sign: "с", flag: "🇰🇬" ) // Киргизия
    static let FJD = Currency(shortName: "FJD", name: "Fijian dollar", sign: "$", flag: "🇫🇯" ) //
    static let GYD = Currency(shortName: "GYD", name: "Guyanese dollar", sign: "$", flag: "🇬🇾" ) // гайана
    static let AOA = Currency(shortName: "AOA", name: "Angolan kwanza", sign: "Kz", flag: "🇦🇴" ) // Ангола
    static let GNF = Currency(shortName: "GNF", name: "Guinean franc", sign: "₣", flag: "🇬🇳" ) //
    static let CUP = Currency(shortName: "CUP", name: "Cuban peso", sign: "$", flag: "🇨🇺" ) //
    static let BDT = Currency(shortName: "BDT", name: "Bangladeshi taka", sign: "৳", flag: "🇧🇩" ) // Бангладеш
    static let MZN = Currency(shortName: "MZN", name: "Mozambican metical", sign: "MT", flag: "🇲🇿" ) //
    static let INR = Currency(shortName: "INR", name: "Indian rupee", sign: "₹", flag: "🇮🇳" ) //
    static let OMR = Currency(shortName: "OMR", name: "Omani rial", sign: "RO", flag: "🇴🇲" ) //
    static let JOD = Currency(shortName: "JOD", name: "Jordanian dinar", sign: "JD", flag: "🇯🇴" ) //
    static let THB = Currency(shortName: "THB", name: "Thai baht", sign: "฿", flag: "🇹🇭" ) // Таиланд
    static let CNY = Currency(shortName: "CNY", name: "Chinese yuan", sign: "¥", flag: "🇨🇳" ) // Юань
    static let COP = Currency(shortName: "COP", name: "Colombian peso", sign: "$", flag: "🇨🇴" ) // Юань
    static let LSL = Currency(shortName: "LSL", name: "Lesotho loti", sign: "L", flag: "🇱🇸" ) // Лесото
    static let CUC = Currency(shortName: "CUC", name: "Cuban convertible peso", sign: "$", flag: "🇨🇺" ) //
    static let MKD = Currency(shortName: "MKD", name: "Macedonian denar", sign: "ден", flag: "🇲🇰" ) // Македоня
    static let PKR = Currency(shortName: "PKR", name: "Pakistani rupee", sign: "Re", flag: "🇵🇰" ) //
    static let LBP = Currency(shortName: "LBP", name: "Lebanese pound", sign: "?", flag: "🇱🇧" ) //
    static let ZAR = Currency(shortName: "ZAR", name: "South African rand", sign: "R", flag: "🇿🇦" ) // ЮАР
    static let AUD = Currency(shortName: "AUD", name: "Australian dollar", sign: "$", flag: "🇦🇺" ) //
    static let TJS = Currency(shortName: "TJS", name: "Tajikistani somoni", sign: "с.", flag: "🇹🇯" ) //
    static let SHP = Currency(shortName: "SHP", name: "Saint Helena pound", sign: "£", flag: "🇸🇭" ) //
    static let IQD = Currency(shortName: "IQD", name: "Iraqi dinar", sign: "ID", flag: "🇮🇶" ) //
    static let VND = Currency(shortName: "VND", name: "Vietnamese đồng", sign: "₫", flag: "🇻🇳" ) // Вьетнам
    static let CAD = Currency(shortName: "CAD", name: "Canadian dollar", sign: "$", flag: "🇨🇦" ) //
    static let SBD = Currency(shortName: "SBD", name: "Solomon Islands dollar", sign: "$", flag: "🇸🇧" ) //
    static let DJF = Currency(shortName: "DJF", name: "Djiboutian franc", sign: "₣", flag: "🇩🇯" ) //
    static let WST = Currency(shortName: "WST", name: "Samoan tālā", sign: "₣", flag: "🇼🇸" ) // Самоа
    static let DKK = Currency(shortName: "DKK", name: "Danish krone", sign: "kr", flag: "🇩🇰" ) //
    static let KES = Currency(shortName: "KES", name: "Kenyan shilling", sign: "KSh", flag: "🇰🇪" ) //
    static let PLN = Currency(shortName: "PLN", name: "Polish złoty", sign: "KSh", flag: "🇵🇱" ) // ПОльша
    static let PYG = Currency(shortName: "PYG", name: "Paraguayan guaraní", sign: "₲", flag: "🇵🇾" ) // Парагвай
    static let TND = Currency(shortName: "TND", name: "Tunisian dinar", sign: "₲", flag: "🇹🇳" ) // Тунисский динар
    static let CVE = Currency(shortName: "CVE", name: "Cape Verdean escudo", sign: "$", flag: "🇨🇻" ) // Кабо-Верде
    static let KZT = Currency(shortName: "KZT", name: "Kazakhstani tenge", sign: "₸", flag: "🇰🇿" ) // Казахстан
    static let LRD = Currency(shortName: "LRD", name: "Liberian dollar", sign: "$", flag: "🇱🇷" ) //
    static let CDF = Currency(shortName: "CDF", name: "Congolese franc", sign: "₣", flag: "🇨🇩" ) //
    static let PEN = Currency(shortName: "PEN", name: "Peruvian sol", sign: "S/", flag: "🇵🇪" ) // Перу
    static let BRL = Currency(shortName: "BRL", name: "Brazilian real", sign: "$", flag: "🇧🇷" ) //
    static let JPY = Currency(shortName: "JPY", name: "Japanese yen", sign: "¥", flag: "🇯🇵" ) // Япония
    static let SRD = Currency(shortName: "SRD", name: "Surinamese dollar", sign: "$", flag: "🇸🇷" ) //
    static let TMT = Currency(shortName: "TMT", name: "Turkmenistan manat", sign: "m", flag: "🇹🇲" ) //
    static let KYD = Currency(shortName: "KYD", name: "Cayman Islands dollar", sign: "$", flag: "🇰🇾" ) //
    static let HKD = Currency(shortName: "HKD", name: "Hong Kong dollar", sign: "$", flag: "🇭🇰" ) //
    static let MNT = Currency(shortName: "MNT", name: "Mongolian tögrög", sign: "$", flag: "🇲🇳" ) // Монголия
    static let MXN = Currency(shortName: "MXN", name: "Mexican peso", sign: "$", flag: "🇲🇽" ) //
    static let CLF = Currency(shortName: "CLF", name: "Chilean Unidad de Fomento", sign: "$", flag: "🇨🇱" ) //
    static let UZS = Currency(shortName: "UZS", name: "Uzbekistani soʻm", sign: "сўм", flag: "🇺🇿" ) //
    static let PAB = Currency(shortName: "PAB", name: "Panamanian balboa", sign: "сўм", flag: "🇵🇦" ) // Панама
    static let GHS = Currency(shortName: "GHS", name: "Ghanaian cedi", sign: "₵", flag: "🇬🇭" ) //
    static let KHR = Currency(shortName: "KHR", name: "Cambodian riel", sign: "៛", flag: "🇰🇭" ) // Камбоджа
    static let ILS = Currency(shortName: "ILS", name: "Israeli new shekel", sign: "₪", flag: "🇮🇱" ) //
    static let IDR = Currency(shortName: "IDR", name: "Indonesian rupiah", sign: "Rp", flag: "🇮🇩" ) //
    static let XCD = Currency(shortName: "XCD", name: "Eastern Caribbean dollar", sign: "$", flag: "🇩🇲" ) // Монтсеррат
    static let DOP = Currency(shortName: "DOP", name: "Dominican peso", sign: "$", flag: "🇩🇴" ) //
    static let ERN = Currency(shortName: "ERN", name: "Eritrean nakfa", sign: "Nfk", flag: "🇪🇷" ) //Эритрея
    static let VUV = Currency(shortName: "VUV", name: "Vanuatu vatu", sign: "Vt", flag: "🇻🇺" ) //Вануату
    static let XOF = Currency(shortName: "XOF", name: "West African CFA franc", sign: "₣", flag: "🇬🇼" ) //Гвинея-Бисау
    static let MWK = Currency(shortName: "MWK", name: "Malawian kwacha", sign: "K", flag: "🇲🇼" ) // Малави
    static let IRR = Currency(shortName: "IRR", name: "Iranian rial", sign: "IR", flag: "🇮🇷" ) //
    static let SDG = Currency(shortName: "SDG", name: "Sudanese pound", sign: "£", flag: "🇸🇩" ) //
    static let KWD = Currency(shortName: "KWD", name: "Kuwaiti dinar", sign: "K", flag: "🇰🇼" ) //
    static let BHD = Currency(shortName: "BHD", name: "Bahraini dinar", sign: "BD", flag: "🇧🇭" ) //
    static let FKP = Currency(shortName: "FKP", name: "Falkland Islands pound", sign: "£", flag: "🇫🇰" ) //
    static let MDL = Currency(shortName: "MDL", name: "Moldovan leu", sign: "L", flag: "🇲🇩" ) //
    static let MUR = Currency(shortName: "MUR", name: "Mauritian rupee", sign: "Re", flag: "🇲🇺" ) // Маврикий
    static let ARS = Currency(shortName: "ARS", name: "Argentine peso", sign: "$", flag: "🇦🇷" ) //
    static let GBP = Currency(shortName: "GBP", name: "British pound", sign: "£", flag: "🇬🇧" ) //
    static let CZK = Currency(shortName: "CZK", name: "Czech koruna", sign: "Kč", flag: "🇨🇿" ) //
    static let MMK = Currency(shortName: "MMK", name: "Burmese kyat", sign: "K", flag: "🇲🇲" ) //Мьянма
    static let TTD = Currency(shortName: "TTD", name: "Trinidad and Tobago dollar", sign: "$", flag: "🇹🇹" ) //Тринидад и Тобаго
    static let ZMW = Currency(shortName: "ZMW", name: "Zambian kwacha", sign: "K", flag: "🇿🇲" ) //
    static let HRK = Currency(shortName: "HRK", name: "Croatian kuna", sign: "Kn", flag: "🇭🇷" ) //
    static let NZD = Currency(shortName: "NZD", name: "New Zealand dollar", sign: "$", flag: "🇳🇿" ) //
    static let BSD = Currency(shortName: "BSD", name: "Bahamian dollar", sign: "$", flag: "🇧🇸" ) // Bahamian Dollar
    static let NAD = Currency(shortName: "NAD", name: "Namibian dollar", sign: "$", flag: "🇳🇦" ) // Namibia Dollar
    static let UYU = Currency(shortName: "UYU", name: "Uruguayan Peso", sign: "$", flag: "🇺🇾" )
    static let BGN = Currency(shortName: "BGN", name: "Bulgarian Lev", sign: "лв", flag: "🇧🇬" )
    static let GIP = Currency(shortName: "GIP", name: "Gibraltar Pound", sign: "£", flag: "🇺🇲" )
    static let LVL = Currency(shortName: "LVL", name: "Latvian lats", sign: "Ls", flag: "🇱🇻" )
    static let EGP = Currency(shortName: "EGP", name: "Egyptian Pound", sign: "£", flag: "🇪🇬" )
    static let CRC = Currency(shortName: "🇨🇷", name: "Costa Rican Colon", sign: "₡", flag: "🇺🇲" )
    static let HUF = Currency(shortName: "HUF", name: "Forint", sign: "Ft", flag: "🇭🇺" ) // венгрия
    static let HNL = Currency(shortName: "HNL", name: "Lempira", sign: "L", flag: "🇭🇳" ) // гондурас
    static let NOK = Currency(shortName: "NOK", name: "Norwegian Krone", sign: "kr", flag: "🇳🇴" )
    static let MOP = Currency(shortName: "MOP", name: "Pataca", sign: "$", flag: "🇲🇴" ) // Мокао
    static let LYD = Currency(shortName: "LYD", name: "Libyan Dinar", sign: "LD", flag: "🇱🇾" )
    static let BBD = Currency(shortName: "BBD", name: "Barbados Dollar", sign: "$", flag: "🇧🇧" )
    static let DZD = Currency(shortName: "DZD", name: "Algerian Dinar", sign: "DA", flag: "🇩🇿" )
    static let KRW = Currency(shortName: "KRW", name: "South Korean Won", sign: "₩", flag: "🇰🇷" )
    static let JMD = Currency(shortName: "JMD", name: "Jamaican Dollar", sign: "$", flag: "🇯🇲" ) //
    static let BOB = Currency(shortName: "BOB", name: "Boliviano", sign: "$", flag: "🇧🇴" ) //
    static let GMD = Currency(shortName: "GMD", name: "Dalasi", sign: "$", flag: "🇬🇲" ) // Гамбия
    static let GTQ = Currency(shortName: "GTQ", name: "Quetzal", sign: "Q", flag: "🇬🇹" ) // Гватемала
    static let KMF = Currency(shortName: "KMF", name: "Comoro Franc", sign: "₣", flag: "🇰🇲" ) // Коморы
    static let QAR = Currency(shortName: "QAR", name: "Qatari Rial", sign: "QR", flag: "🇶🇦" ) //
    static let UAH = Currency(shortName: "UAH", name: "Hryvnia", sign: "₴", flag: "🇺🇦" ) //
    static let SZL = Currency(shortName: "SZL", name: "Lilangeni", sign: "L", flag: "🇸🇿" ) // Свазиленд
    static let SAR = Currency(shortName: "SAR", name: "Saudi Riyal", sign: "SR", flag: "🇸🇦" ) // Saudi Riyal
    static let AED = Currency(shortName: "AED", name: "UAE Dirham", sign: "Dh", flag: "🇦🇪" ) //
    static let ISK = Currency(shortName: "ISK", name: "Iceland Krona", sign: "kr", flag: "🇮🇸" ) //
    static let AZN = Currency(shortName: "AZN", name: "Azerbaijanian Manat", sign: "₼", flag: "🇦🇿" ) //
    static let BZD = Currency(shortName: "BZD", name: "Belize Dollar", sign: "$", flag: "🇧🇿" ) //
    static let AFN = Currency(shortName: "AFN", name: "Afghani", sign: "Af", flag: "🇦🇫" ) //
    static let PHP = Currency(shortName: "PHP", name: "Philippine Peso", sign: "₱", flag: "🇵🇭" ) //
    static let PGK = Currency(shortName: "PGK", name: "Kina", sign: "K", flag: "🇵🇬" ) //
    static let ETB = Currency(shortName: "ETB", name: "Ethiopian Birr", sign: "Br", flag: "🇪🇹" ) //
    static let BIF = Currency(shortName: "BIF", name: "Burundi Franc", sign: "₣", flag: "🇧🇮" ) //
    static let VEF = Currency(shortName: "VEF", name: "Bolivar", sign: "Bs", flag: "🇻🇪" ) // венесуэлла
    static let AWG = Currency(shortName: "AWG", name: "Aruban Guilder", sign: "ƒ", flag: "🇦🇼" ) // Аруба
    static let KPW = Currency(shortName: "KPW", name: "North Korean Won", sign: "원", flag: "🇰🇵" ) //
    static let ZWL = Currency(shortName: "ZWL", name: "Zimbabwe Dollar", sign: "Z$", flag: "🇿🇼" ) //
    static let TOP = Currency(shortName: "TOP", name: "Pa’anga", sign: "$", flag: "🇹🇴" ) // Тонга
    static let SOS = Currency(shortName: "SOS", name: "Somali Shilling", sign: "S", flag: "🇸🇴" ) //
    static let LTL = Currency(shortName: "LTL", name: "Lithuanian litas", sign: "Lt", flag: "🇱🇹" ) // литва
    static let MGA = Currency(shortName: "MGA", name: "Malagasy ariary", sign: "Ar", flag: "🇲🇬" ) // мадагаскар
    static let SCR = Currency(shortName: "SCR", name: "Seychelles Rupee", sign: "Re", flag: "🇸🇨" ) //
    static let SYP = Currency(shortName: "SYP", name: "Syrian Pound", sign: "S£", flag: "🇸🇾" ) //
    static let TRY = Currency(shortName: "TRY", name: "Turkish Lira", sign: "₺", flag: "🇹🇷" ) //
    static let RSD = Currency(shortName: "RSD", name: "Serbian Dinar", sign: "din", flag: "🇷🇸" ) //
    static let BYN = Currency(shortName: "BYR", name: "Belarussian Ruble", sign: "Br", flag: "🇧🇾" ) //
    static let NPR = Currency(shortName: "NPR", name: "Nepalese Rupee", sign: "Re", flag: "🇳🇵" ) // Непал
    static let UGX = Currency(shortName: "UGX", name: "Uganda Shilling", sign: "Ush", flag: "🇺🇬" ) //
    static let CHF = Currency(shortName: "CHF", name: "Swiss Franc", sign: "₣", flag: "🇨🇭" ) //
    static let YER = Currency(shortName: "YER", name: "Yemeni Rial", sign: "YR", flag: "🇾🇪" ) // Йемен
    static let XPF = Currency(shortName: "XPF", name: "CFP Franc", sign: "₣", flag: "🇳🇨" ) // Новая Каледония
    static let LKR = Currency(shortName: "LKR", name: "Sri Lanka Rupee", sign: "Re", flag: "🇱🇰" ) // Шри Ланка
    static let RUB = Currency(shortName: "RUB", name: "Российский рубль", sign: "₽", flag: "🇷🇺" )
    static let EUR = Currency(shortName: "EUR", name: "Евро", sign: "€", flag: "🇪🇺"  )
    static let USD = Currency(shortName: "USD", name: "Доллар США", sign: "$", flag: "🇺🇲" )

    
    static let allCurrencies = [AED, AFN, ALL, AMD, AOA, ARS, AUD, AWG, AZN, BBD, BDT, BGN, BHD, BIF, BND, BOB, BRL, BSD, BTN, BWP, BYN, BZD, CAD, CDF, CHF, CLF, CNY, COP, CRC, CUC, CUP, CVE, CZK, DJF, DKK, DOP, DZD, EGP, ERN, ETB, EUR, FJD, FKP, GBP, GEL, GHS, GIP, GMD, GNF, GTQ, GYD, HKD, HNL, HRK, HTG, HUF, IDR, ILS, INR, IQD, IRR, ISK, JEP, JMD, JOD, JPY, KES, KGS, KHR, KMF, KPW, KRW, KWD, KYD, KZT, LAK, LBP, LKR, LRD, LSL, LTL, LVL, LYD, MAD, MDL, MGA, MKD, MMK, MNT, MOP, MRO, MUR, MVR, MWK, MXN, MYR, MZN, NAD, NGN, NOK, NPR, NZD, OMR, PAB, PEN, PGK, PHP, PKR, PLN, PYG, QAR, RON, RSD, RUB, RWF, SAR, SBD, SCR, SDG, SGD, SHP, SLL, SOS, SRD, SVC, SYP, SZL, THB, TJS, TMT, TND, TOP, TRY, TTD, TWD, TZS, UAH, UGX, USD,
                                               UYU, UZS, VEF, VND, VUV, WST, XAF, XCD, XOF, XPF, YER, ZAR, ZMW, ZWL]
    
    public static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.shortName == rhs.shortName
    }
    
    var hashValue: Int {
        return shortName.hashValue
    }
    
    init?(rawValue: String) {
        guard let currency = Currency.allCurrencies.first(where: {$0.shortName == rawValue}) else {
            return nil
        }
        self = currency
    }
    
    var rawValue: String {
        return shortName
    }
    
    
    var description: String {
        return shortName
    }
}


