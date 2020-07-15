// --------------------------------------------------------------------------------------------------------------------
// --------------------------------------------------- DUMMY DATA -----------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------

landlords: (
    [landlordId: til 3]
    // details
    landlordName: (`$"Jan Jensen";`$"John Johnson";`$"Alice Alisson");
    landlordEmail: (`$"jan.jensen@yahoo.com";`$"john.johnson@gmail.com";`$"alice.alisson@hotmail.com");
    landlordPhone: (`$"+447800000000";`$"+447823234234";`$"+447835345331")
    );

tenants: (
    [tenantId: til 10]
    // details
    tenantName: (`$"Cristian Matache";`$"Oana Ciocioman";`$"Alex Toma";`$"Andrei Puiu";`$"Andi Bahou";`$"Larissa Schrempp";
           `$"Simona Halep";`$"Roger Federer";`$"Martina Hingis";`$"Belinda Bencic");
    tenantEmail: (`$"cristian@matache.com";`$"oana@ciocioman.com";`$"alex@toma.com";`$"andrei@puiu.com";`$"andi@bahou.com";
             `$"larissa@schrempp.com";`$"simo@halep.com"; `$"roger@f.com";`$"martina@hingis.com";`$"b@bencic.com");
    tenantPhone: (`$"+447800000001";`$"+447823234232";`$"+447835345333";`$"+447800000004";`$"+447823234235";`$"+447835345336";
                  `$"+447800000007";`$"+447823234238";`$"+447835345339";`$"+447800000010");
    age: 35 29 40 21 44 30 22 28 39 33;
    employment: 1100110101b;
    yearlyIncome: 170000 190000 190000 110000 130000 170000 150000 180000 100000 130000; // generated 10000 * 10 + 10?10
    job: `actor`painter`carpenter`student`banker`pilot`teacher`athlete`athlete`athlete
    );

flats: (
    [flatId: til 15]
    landlordId: 15#til 3;
    // details
    postcode: `W36AA`W36AB`W36AC`W36AD`W36AE`W36AF`W36AG`W36AH`W36AI`W36AJ`W36AK`W36AL`W36AM`W36AN`W36AO;
    bedrooms: 3 1 3 3 2 2 3 2 3 2 1 1 1 2 3j;            // 15?1 2 3
    bathrooms: 2 1 1 2 1 2 2 2 1 2 1 1 1 1 2j;           // 15?1 2
    area: 65 25 55 65 40 50 65 50 55 50 25 25 25 40 65j; // update area: (dorm * 15) + (bai * 10)
    flatName: ("Luxury Flat in Bellevue";"Flat in Oerlikon";"Flat with Zurich lake view";
               "Student-friendly house in Hardbrucke"; "Luxury Flat in Thalwil";"Sunny flat in Altstetten";
               "Bright flat in Pfaffikon";"Luxury flat in Wiedikon"; "Palatial house in Paradeplatz";
               "Luxury house near Zurich HB";"Cosy place in Langstrasse";"Cosy flat near Enge";
               "Flat 10 minutes walk from Escher-Wyss Platz";"Historical flat in Schiffbau";
               "Flat in Palatial Building near Opera");
    rentPricePM: 11000 3000 5000 5000 9000 4000 4000 3000 9000 5000 3000 6000 2000 8000 6000j; //1000 * 15?2+til 10
    flatImage: (
    `$"https://media-cdn.tripadvisor.com/media/photo-s/09/31/49/e6/opernhaus.jpg";
    `$"https://media.homegate.ch/v1567005508/listings/x551/images/201908281718288032860.jpg/s/703/474";
    `$"https://q-cf.bstatic.com/images/hotel/max1280x900/113/113749007.jpg";
    `$"https://s3.eu-west-2.amazonaws.com/assets.crm-students.com/2018/10/VibeStudentLiving-Studio-May17.jpg";
    `$"https://i.pinimg.com/originals/67/0b/75/670b7513b2caadd4e3d77ae06f5ce3a4.jpg";
    `$"https://img.staticmb.com/mbimages/project/Photo_h310_w462/2019/07/09/Project-Photo-4-CBR-Aavani-Bangalore-5124823_545_1050_310_462.jpg";
    `$"https://i2.wp.com/wanderingcarol.com/wp-content/uploads/2018/11/Palazzo-Grimani-5-star-accommodation-in-Venice.jpg?fit=700%2C467&ssl=1";
    `$"data:image/jpeg;base64,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";
    `$"http://www.ritzparis.com/sites/default/files/styles/1440x748/public/images/card_page/slideshow/ritz-paris-hotel-suite-imperiale-chambre1_0.jpg?itok=TryUZ831";
    `$"https://media.inmobalia.com/imgV1/B98Le8~d7MYGjAUxlK_9XSGXnhM8fik2ofQwHkegNv18kwMRt3ikSHiLdNIignsoFOGO_nge1ro7Rhx9NJp~a9GmYK6Tz4XHCwfu~3GivTHiY0alxX4FiOk5z0xpB7Ha1YYxm6zyDhBd31k7RO_FWKG5PQ2lCklC~o6bPyc3iQmKGeodI2GsOw7AOBcomIyh7fI6UMSVAf4NVz15GhqJchw4TPCSjB~rNVLmxWoFWeZLvR~m~ln8TfcWfHN7sx2ypbQBxMGlUjBV3MiqRQp4nclA0Q7xKfabrJtJlbVrznZvff4vNOQ-.jpg";
    `$"https://www.moriliving.com/images/home/img_slide_002.jpg";
    `$"https://i.pinimg.com/originals/ab/c1/f5/abc1f5ba4efe89cc8080a9fda144918c.jpg";
    `$"https://static.independent.co.uk/s3fs-public/thumbnails/image/2019/02/27/15/zurich-view.jpg?w968h681";
    `$"https://i.dailymail.co.uk/i/pix/2011/04/19/article-1378394-0BB0F63200000578-575_634x389.jpg";
    `$"https://i.dailymail.co.uk/i/pix/2015/01/20/24DEA1E000000578-2918215-image-m-35_1421757448600.jpg"
    //`$"https://i.pinimg.com/originals/d6/c5/03/d6c503a52f176614f4b6591d77b15719.jpg"
    //`$"https://images.unsplash.com/photo-1529408686214-b48b8532f72c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=986e2dee5c1b488d877ad7ba1afaf2ec&auto=format&fit=crop&w=1350&q=80";
    )
    );

interested: ([]
    flatId:   0 0 1 1 1 1 2 2 3 3 3 3 4 4 5 5 5 5 6 6 7 7 7 7 8 8 9 9 9 9 10 10 10 10 11 11 11 11 12 12 12 12 13 13 14 14 14 14 14j;
    tenantId: 9 7 0 3 9 7 2 0 2 1 5 0 8 3 3 1 4 5 9 7 8 2 0 9 7 4 0 8 3 7 0 4 2 3 8 4 1 9 8 2 4 3 4 6 5 9 0 8 1j;
    viewed: 0100001100000011011110000011101011000110111111100b;   // 49?01b
    declined: 0100101100000011100011000000101000100110011100100b; // 49?01b
    viewingDate: 2019.11.01 2019.08.13 2019.09.13 2019.10.24 2019.10.14 2019.10.13 2019.07.03 2019.06.04 2019.09.11
                 2019.10.23 2019.09.04 2019.12.04 2019.09.09 2019.09.01 2019.05.13 2019.04.17 2019.10.29 2019.09.16
                 2019.08.28 2019.09.26 2019.09.13 2019.10.16 2019.11.28 2019.10.12 2019.09.26 2019.10.10 2019.09.11
                 2019.09.25 2019.09.26 2019.12.02 2019.09.16 2019.10.29 2019.09.11 2019.09.09 2019.09.15 2019.10.10
                 2019.09.18 2019.08.15 2019.08.06 2019.10.15 2019.09.24 2019.09.26 2019.08.23 2019.08.21 2019.09.10
                 2019.09.24 2019.08.01 2019.09.06 2019.10.09;     //2019.09.01 + 49?til 100
    viewingConfirmed: 0101101100111011011110110011101011000110111111101b
    );


// --------------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------- FUNCTIONS -----------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------

allInfo: {
    :((interested lj tenants) lj flats) lj landlords
    };


getFlatsInfo: {
    // tenant - home page
    nInterestedPeople: select totalInterested:count i by flatId from allInfo[];
    nUpInterestedPeople: select nUpInterested:count i by flatId from allInfo[] where not declined;

    nViewings: select totalViewings:count i by flatId from allInfo[] where viewed;
    nUpViewings: select nUpViewings:count i by flatId from allInfo[] where viewed, not declined;

    res: (((flats lj nInterestedPeople) lj nViewings) lj nUpInterestedPeople) lj nUpViewings;
    :update 0^totalInterested, 0^totalViewings, 0^nUpInterested, 0^nUpViewings from res;
    };


getFlatInfo: {[targetFlatId]
    :select postcode, bedrooms, bathrooms, area, flatName, rentPricePM, flatImage, totalInterested,
            totalViewings, nUpInterested, nUpViewings
        from getFlatsInfo[]
        where flatId=targetFlatId
    };



getFlatsOverviewPerLandlord: {[targetLandlordId]
    // landlord - home page
    :select from getFlatsInfo[] where landlordId=targetLandlordId
    };


getInfoPerFlat: {[targetFlatId]
    // landlord - flat info page
    :`declined xasc `viewed xdesc select from allInfo[] where flatId=targetFlatId;
    };


declineTenant: {[targetFlatId; targetTenantId]
    // landlord - decline tenant - redirect to flat info page
    interested::update declined:1b from interested where flatId=targetFlatId, tenantId=targetTenantId
    };

//getInfoPerFlat[10]
//declineTenant[10; 2]


getTenantInfo: {[targetTenantId; fieldName]
    // tenant - all pages
    if[11h <> abs type fieldName; '"Type of fieldName should be symbol or a list of symbols"];
    :(exec from tenants where tenantId=targetTenantId)[fieldName]
    };


getLandlordInfo: {[targetLandlordId; fieldName]
    // landlord - all pages
    if[11h <> abs type fieldName; '"Type of fieldName should be symbol or a list of symbols"];
    :(exec from landlords where landlordId=targetLandlordId)[fieldName]
    };


scheduleViewing: {[targetFlatId; targetTenantId; targetDate]
    // tenant - home page - back of card - redirect to tenant's viewings page
    toAppend: ([] flatId: enlist targetFlatId; tenantId: targetTenantId; viewed: 0b; declined: 0b;
               viewingDate: targetDate; viewingConfirmed: 0b);
    if[not all (select flatId, tenantId from toAppend) in (select flatId, tenantId from interested);
        interested::interested,toAppend]
    };


amendViewing:{[targetFlatId; targetTenantId; targetDate; confirmOrCancel]
    if[not confirmOrCancel in `confirm`cancel; '"confirmOrCancel must be `confirm or `cancel"];

    if[confirmOrCancel=`confirm;
        interested:: update viewingConfirmed: 1b from interested
                        where flatId=targetFlatId, tenantId=targetTenantId, viewingDate=targetDate];

    if[confirmOrCancel=`cancel;
        interested:: delete from interested
                        where flatId=targetFlatId, tenantId=targetTenantId, viewingDate=targetDate]
    };

//getInfoPerFlat[10]
//scheduleViewing[10; 5; 2019.01.01]
//amendViewing[10;2;2019.09.11;`cancel]


getViewings: {[tenantOrLandlord; targetId; typeOfViewing]
    // tenant/landlord - viewings page
    if[not typeOfViewing in `upcoming`notConfirmed`viewed`declined;
        '"typeOfViewing must be `upcoming,`notConfirmed,`viewed,`declined"];
    if[not tenantOrLandlord in `tenant`landlord;
        '"tenantOrLandlord must be `tenant or `landlord"];
    viewings: $[tenantOrLandlord=`tenant;
        select from allInfo[] where tenantId=targetId;
        select from allInfo[] where landlordId=targetId
    ];
    :$[
    typeOfViewing=`upcoming;
        select from viewings where viewingConfirmed, not viewed, not declined;
    typeOfViewing=`notConfirmed;
        select from viewings where not viewingConfirmed, not declined;
    typeOfViewing=`viewed;
        select from viewings where viewed, not declined;
    typeOfViewing=`declined;
        select from viewings where declined
    ] lj getFlatsInfo[]
    };


getLandlordPerFlat: {[targetFlatId]
    :(exec landlordId from flats where flatId=targetFlatId)[0]
    };


getViewingsPerFlat: {[targetFlatId; typeOfViewing]
    landlordId: getLandlordPerFlat[targetFlatId];
    :select from getViewings[`landlord;landlordId;typeOfViewing] where flatId=targetFlatId
    };


// --------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------ TESTS -------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------


.test.testAllInfo: {
    $[(count where not exec nDistinctTenants=nTenants from
        select nDistinctTenants:count distinct tenantId, nTenants:count tenantId by flatId from allInfo[]) = 0;
        show "No duplicates in interested tenants";
        '"Duplicates in interested tenants"]
    };
//.test.testAllInfo[]
