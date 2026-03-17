function getHeader(str){
    let header = []
    if(str == "directors"){
        header = [
            //{title : "Айди",key : "id"},
            {title : "Имя и фамилия",key:"nameAndSurname"}
        ]
    }
    if(str == "actors"){
        header = [
            //{title : "Айди",key : "id"},
            {title : "Имя и фамилия",key:"nameAndSurname"}
        ]
    }
    if(str == "directors"){
        header = [
            //{title : "Айди",key : "id"},
            {title : "Имя и фамилия",key:"nameAndSurname"}
        ]
    }
    if(str == "countries"){
        header = [
            //{title : "Айди",key : "id"},
            {title : "Название страны",key:"countryName"}
        ]
    }
    if(str == "genres"){
        header = [
            //{title : "Айди",key : "id"},
            {title : "Название жанра",key:"genreName"}
        ]
    }
    if(str == "halls"){
        header = [
            //{title : "Айди",key : "id"},
            {title : "Номер зала",key:"hallNumber"},
            {title : "Тип зала",key:"hallType"},
            {title : "Коэффициент зала",key:"hallCoefficient"},
        ]
    }
    if(str == "seats"){
        header = [
            //{title : "Айди",key : "id"},
            {title : "Номер зала",key:"hallNumber"},
            
            {title : "Коэффициент зала",key:"coefficient"},
            {title : "Номер места",key:"seatNumber"},
            {title : "Номер ряда",key:"rowNumber"},
        ]
    }
    if(str == "accounts"){
        header = [
            //{title : "Айди",key : "id"},
            {title : "Логин",key:"login"},
            {title : "Пароль",key:"password"},
            {title : "Роль",key:"role"},
        ]
    }
    return header
}

export default getHeader